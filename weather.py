#!/usr/bin/env python
import requests
import datetime

FORECASTURL = "https://cdn-secure.buienalarm.nl/api/3.4/forecast.php?lat={}&lon={}&region=nl&unit=mm/u"


def get_location():
    url = "https://geoip.maxmind.com/geoip/v2.1/city/me"
    response = requests.get(url, headers={"Referer": "https://www.maxmind.com/"})
    if response.status_code == 200:
        return response.json()
    else:
        return None


def percipation_to_text(percipation):
    rain_starts_at = None
    rain_ends_at = None
    rain_points = []
    rain_rate = 0
    now = datetime.datetime.now()
    for idx, item in enumerate(percipation):
        if item > 0 and not rain_starts_at:
            # Each datapoint is 5 minutes
            rain_starts_at = now + datetime.timedelta(minutes=idx * 5)
            rain_points.append(item)
        elif item == 0 and rain_starts_at and not rain_ends_at:
            rain_ends_at = now + datetime.timedelta(minutes=idx * 5)
        elif item > 0 and rain_starts_at and not rain_ends_at:
            rain_points.append(item)

    if rain_points:
        max_rain = max(rain_points)
        if max_rain < 0.25:
            rain_rate = 1
        elif max_rain < 1:
            rain_rate = 2
        else:
            rain_rate = 3

    if not rain_starts_at:
        return ""
    else:
        return f"{rain_rate * "🌢"} at {rain_starts_at.strftime('%H:%M')} until {rain_ends_at.strftime('%H:%M')}"


def percipation_summary(percipation):
    data = ""
    now = datetime.datetime.now()
    for idx, item in enumerate(percipation):
        data += "{}: {}mm/h\n".format(
            (now + datetime.timedelta(minutes=idx * 5)).strftime("%H:%M"), item
        )
    return data


def get_forecast(lat, lon):
    forecast = requests.get(FORECASTURL.format(lat, lon)).json()
    title = ""
    rain = percipation_to_text(forecast["precip"])
    if not rain:
        title = f"{forecast["temp"]}°C\n---\nNo rain expected for the next 2 hours"
    else:
        title = f"{forecast["temp"]}°C, {rain}\n---\n{percipation_summary(forecast["precip"])}"
    return title


def main():
    location = get_location()
    if location:
        forecast = get_forecast(
            location["location"]["latitude"], location["location"]["longitude"]
        )
        forecast += f"\n📍{location["country"]["names"]["en"]}, {location["city"]["names"]["en"]}, {location["postal"]["code"]}"
        forecast += (
            f"\n🌐{location["traits"]["isp"]}, {location["traits"]["ip_address"]}"
        )
        print(forecast)


if __name__ == "__main__":
    main()
