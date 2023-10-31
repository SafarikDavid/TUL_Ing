import random
import string
import timeit
import matplotlib.pyplot as plt

routes = []


def find_paths(node, cities, path, distance):
    # Add way point
    path.append(node)

    # Calculate path length from current to last node
    if len(path) > 1:
        distance += cities[path[-2]][node]

    # If path contains all cities and is not a dead end,
    # add path from last to first city and return.
    if (len(cities) == len(path)) and (path[0] in cities[path[-1]]):
        global routes
        path.append(path[0])
        distance += cities[path[-2]][path[0]]
        # print(path, distance)
        routes.append([distance, path])
        return

    # Fork paths for all possible cities not yet used
    for city in cities:
        if (city not in path) and (node in cities[city]):
            find_paths(city, dict(cities), list(path), distance)


def get_random_string(length):
    # choose from all lowercase letter
    letters = string.ascii_uppercase
    result_str = ''.join(random.choice(letters) for i in range(length))
    return result_str


def generate_graph(n_cities, dist_min, dist_max, min_paths_from, max_paths_from):
    cities_dic = {}

    for ii in range(n_cities):
        city_name = get_random_string(random.randint(1, 6))
        cities_dic[city_name] = {}
    cities_list = list(cities_dic.keys())
    for key in cities_list:
        n_paths_for_city = 0
        target_path_count_for_city = random.randint(min_paths_from, max_paths_from)
        while n_paths_for_city < target_path_count_for_city:
            path_to = random.choice(cities_list)
            if path_to == key:
                continue
            distance = random.randint(dist_min, dist_max)
            cities_dic[key][path_to] = distance
            cities_dic[path_to][key] = distance
            n_paths_for_city += 1
    return cities_dic


if __name__ == '__main__':
    random.seed(42)
    x_axis = range(3, 15)
    times = []
    # hl, = plt.plot([], [])
    for i in x_axis:
        print("Number of cities: ", i)
        cities = generate_graph(i, 50, 500, 2, max(2, i-2))
        print(cities)
        start_time = timeit.default_timer()
        start = random.choice(list(cities.keys()))
        find_paths(start, cities, [], 0)
        routes.sort()
        time = timeit.default_timer() - start_time
        times.append(time)
        print("The difference of time is :", time)
        if len(routes) != 0:
            print("Shortest route: %s" % routes[0])
        else:
            print("FAIL!")
        # PLOTTING THE POINTS
        plt.plot(x_axis[0:len(times)], times)
        plt.scatter(x_axis[0:len(times)], times)

        plt.title('Number of cities x Execution time')
        plt.xlabel("n cities")
        plt.ylabel("Execution time [s]")

        # DRAW, PAUSE AND CLEAR
        plt.draw()
        plt.grid()
        plt.pause(0.1)
        plt.clf()

    plt.plot(x_axis[0:len(times)], times)
    plt.scatter(x_axis[0:len(times)], times)
    plt.title('Number of cities x Execution time')
    plt.xlabel("n cities")
    plt.ylabel("Execution time [s]")
    plt.grid()
    plt.show()
