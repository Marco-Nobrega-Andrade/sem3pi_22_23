<div align="center">

# Farm Management System

Software for a farm that grows crops and sells them in baskets. The farm manager plans the work in the fields with sensor data behind it, and the delivery side works out which producers fill each order and the shortest way to get it to the client's pickup hub.

![Java](https://img.shields.io/badge/Java-17-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![Oracle](https://img.shields.io/badge/Oracle-PL%2FSQL-F80000?style=for-the-badge&logo=oracle&logoColor=white)
![C](https://img.shields.io/badge/C-gcc-A8B9CC?style=for-the-badge&logo=c&logoColor=white)
![Assembly](https://img.shields.io/badge/Assembly-x86--64-6E4C13?style=for-the-badge&logoColor=white)
![JUnit](https://img.shields.io/badge/JUnit-tests-25A162?style=for-the-badge&logo=junit5&logoColor=white)

[Objectives](#objectives) · [Features](#features) · [Architecture](#architecture) · [Algorithms](#algorithms) · [Team](#team)

<sub>3rd-semester integrative project · Informatics Engineering · <a href="https://www.isep.ipp.pt">ISEP</a>, Porto · 2022–23</sub>

</div>


## Objectives

The brief imagined a farm business asking for one system to run its fields and its produce deliveries. These were the goals:

- [x] Keep a record of the farm in a database: sectors, crops, plantings, watering, fertilising, harvests and orders
- [x] Let the farm manager react to the weather by reading sensor data, moving or cancelling planned work, and checking an audit trail of every change
- [x] Plan the deliveries: choose the hubs, build each day's shipment list, route it and report how well each basket was filled
- [x] Work as a team of five in sprints, with a user story, acceptance criteria, design and tests for each requirement
- [x] Bring four courses together in one project: databases (BDDAD), data structures and graphs (ESINF), computer architecture in C and assembly (ARQCP) and applied physics (FSIAP)


## Features

The repo has one folder per course, and each one covers a different part of the farm.

| | Part | What it does |
|:-:| --- | --- |
| 🗄️ | **Database** (BDDAD) | An Oracle schema of about 30 tables; PL/SQL to add sectors, crops, plantings, watering and fertilising, register orders and payments, and list sectors by area, crop or profit; triggers that keep an audit log; imports of sensor readings and hubs from input tables; a data warehouse for production and sales by year, month, sector, crop, client and hub |
| 🚚 | **Delivery network** (ESINF) | A Java console app that loads clients, companies and producers with the distances between them, checks the network is connected, picks the hubs, finds each client's closest hub, builds the minimum network, simulates an irrigation controller, makes daily shipment lists with or without a limit on producers, plans the delivery routes and gives statistics per basket, client, producer and hub |
| 🌦️ | **Sensors** (ARQCP) | A C program with assembly parts that simulates six kinds of weather and soil sensors, lets you add, remove or change sensors while it runs, fixes readings that go out of range, builds a daily summary matrix and exports both to CSV |
| 🌡️ | **Cold storage** (FSIAP) | A report on a warehouse with zones kept at -10, 0 and 10 °C: wall and roof materials, thermal resistances, the energy needed each hour to keep every zone cold, better wall materials and the cooling power required |

## Architecture

In the full system, sensor readings go into the database, the farm manager plans from there, and the delivery network ships what the farm sells:

```
Sensors (C, assembly)  →  Database (Oracle, PL/SQL)  →  Delivery network (Java)
```

In this repo each part is its own program, because each course graded its own folder. The sensor simulator writes CSV files, the database reads sensor lines from an input table (`InputSensor`), and the Java app loads clients, producers, distances and baskets from the CSV files in `ESINF/Files`. Inside the Java app the graph code is generic and kept apart from the farm: `Graph` has a map and a matrix version, `Algorithms` works on either one, and `DistributionNetwork` just calls it with its own places and roads.

The only library is JUnit, for the Java tests.

## Algorithms

The delivery network is a graph where clients, companies and producers are the vertices and the roads between them, with their distance, are the edges. A BFS checks that everything is connected and, run between every pair, gives the most roads any two places are apart. The hubs are the N companies with the shortest average distance to everyone else, found with Dijkstra from each company, and then every client gets its closest hub (O(V³·H) in the worst case). Kruskal gives the shortest network that still reaches every client and producer.

Each day, the clients' baskets are filled from the producers' stock. Whatever a producer doesn't sell carries over to the next day, but products only last three days. The restricted version only uses the N producers closest to the client's hub, nearest first. Once a list exists, Dijkstra from the hub gives the route to each producer and the total distance, and a final pass counts the full, partial and missing products per basket, client, producer and hub.

Sensor values come from a PCG32 random number generator written in x86-64 assembly. Each new reading is the last one plus a small random step, so the values drift slowly the way real weather does instead of jumping around. Readings outside a sensor's limits are counted as errors and generated again.

We checked the Java code with JUnit on small and big CSV datasets, and the sprint reports in `ESINF/Files/Relatórios` have a complexity analysis for each user story.

## Project structure

```
BDDAD/                         Oracle database
├── model/                     conceptual, relational and data warehouse diagrams
├── INSERTS/                   scripts that create the tables and load test data
└── US202 … US216/             PL/SQL functions, procedures, triggers and docs per user story
ESINF/                         Java 17 Maven project
├── src/main/java/Project/
│   ├── graph/                 generic graph (map and matrix) and its algorithms
│   └── model/                 network, shipments, irrigation, analytics, console menu
├── src/test/java/             JUnit tests
└── Files/                     CSV datasets, class diagrams, user story docs and sprint reports
ARQCP/                         C and assembly sensor simulator, built with make
FSIAP/                         physics report (PDF) and user story docs
```

> The user story docs and reports are written in Portuguese.

> Originally this project was developed on Bitbucket and its earlier commit history was lost.

## Team

<table align="center">
  <tr>
    <td align="center" width="150">
      <a href="https://github.com/Marco-Nobrega-Andrade"><img src="https://github.com/Marco-Nobrega-Andrade.png?size=200" width="100" alt="Marco Andrade"/></a><br>
      <b>Marco Andrade</b><br>
      <a href="https://github.com/Marco-Nobrega-Andrade">@Marco-Nobrega-Andrade</a>
      <br><br>
      <a href="https://github.com/Joao-Batista-Isep"><img src="https://github.com/Joao-Batista-Isep.png?size=200" width="100" alt="João Batista"/></a><br>
      <b>João Batista</b><br>
      <a href="https://github.com/Joao-Batista-Isep">@Joao-Batista-Isep</a>
    </td>
    <td align="center" width="150">
      <a href="https://github.com/SrMasterAD"><img src="https://github.com/SrMasterAD.png?size=200" width="100" alt="David Dias"/></a><br>
      <b>David Dias</b><br>
      <a href="https://github.com/SrMasterAD">@SrMasterAD</a>
      <br><br>
      <a href="https://github.com/DiogoAraujo-ISEP"><img src="https://github.com/DiogoAraujo-ISEP.png?size=200" width="100" alt="Diogo Araújo"/></a><br>
      <b>Diogo Araújo</b><br>
      <a href="https://github.com/DiogoAraujo-ISEP">@DiogoAraujo-ISEP</a>
    </td>
    <td align="center" width="150">
      <a href="https://github.com/EzequielEstima-ISEP"><img src="https://github.com/EzequielEstima-ISEP.png?size=200" width="100" alt="Ezequiel Estima"/></a><br>
      <b>Ezequiel Estima</b><br>
      <a href="https://github.com/EzequielEstima-ISEP">@EzequielEstima-ISEP</a>
    </td>
  </tr>
</table>
