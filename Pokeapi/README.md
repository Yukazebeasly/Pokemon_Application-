# Pokémon
Author: Jhian Mae Calumba

Coursework: Information Technology – Managing Application Data (Communicating with Services)


## Project Overview

This project is an extension of the Pokedex mobile application built with Flutter and Dart. It transitions from static local asset files to dynamic client-server communication using the public PokéAPI (`[https://pokeapi.co/api/v2/pokemon/](https://pokeapi.co/api/v2/pokemon/){name}`). The application presents Pokémon data inside a custom trading card layout, featuring asynchronous HTTP requests, robust JSON decoding, error management, and concurrency control.


## How the Application Handles Service Communication

1. Successful Requests (`200 OK`):
* The application initiates an asynchronous `http.get()` request to `[https://pokeapi.co/api/v2/pokemon/](https://pokeapi.co/api/v2/pokemon/){name}` using the `http` package.
* Upon receiving a `200 OK` status code, the raw response body is decoded using `dart:convert` (`jsonDecode()`).
* The decoded map is mapped into the `Pokemon` data model, extracting fields such as the name, ID, height, weight, types, abilities, held items, sprite URL, and moves list.


2. Unsuccessful Responses (Client / Server Errors):
* If a user queries a Pokémon that does not exist (e.g., `thispokemondoesnotexist`), the server responds with a `404 Not Found` status code.
* The application detects this via the status code check (`response.statusCode != 200`), prevents parsing invalid data, and displays a user-friendly error message instead of crashing.


3. Network & Connectivity Failures:
* When the device is offline or the service is entirely unreachable, the request throws an asynchronous exception (e.g., `SocketException`).
* The `try-catch` block catches this network failure and alerts the user that the connection could not be established, distinguishing connectivity drops from invalid API searches.


## Proposed Offline Strategy

To ensure the application remains useful when a device has no internet connection, the following offline strategy is proposed:

* Local Caching: Successfully fetched Pokémon JSON responses can be serialized and stored locally using a lightweight local storage package (such as `shared_preferences` or a local SQLite/Isar database).
* Fallback Behavior: When network communication fails or the device is offline, the application can automatically fall back to querying the last locally cached JSON data for the requested Pokémon.
* Freshness Indicators: The UI will display a small visual indicator notifying the user that the displayed information is loaded from local cache and may be outdated, alongside a manual retry option to refresh data once connectivity is restored.