import Foundation

struct GameLevel: Identifiable {
    let id = UUID()
    let levelID: Int
    let title: String
    let cards: [Card]
    let description: String
    let fact: String
    let isSpecial: Bool
    let requiredPoints: Int
    
    static let sampleLevels: [GameLevel] = [
        GameLevel(
            levelID: 0,
            title: "Animals by Size",
            cards: [
                Card(value: "Mouse", correctPosition: 0),
                Card(value: "Cat", correctPosition: 1),
                Card(value: "Dog", correctPosition: 2),
                Card(value: "Horse", correctPosition: 3),
                Card(value: "Elephant", correctPosition: 4)
            ],
            description: "Arrange the animals from smallest to largest.",
            fact: "The elephant is the largest land animal on Earth!",
            isSpecial: false,
            requiredPoints: 0
        ),
        GameLevel(
            levelID: 1,
            title: "Fruits Alphabetically",
            cards: [
                Card(value: "Apple", correctPosition: 0),
                Card(value: "Banana", correctPosition: 1),
                Card(value: "Kiwi", correctPosition: 2),
                Card(value: "Orange", correctPosition: 3),
                Card(value: "Pear", correctPosition: 4)
            ],
            description: "Arrange the fruits in alphabetical order.",
            fact: "The most popular fruit in the world is the banana!",
            isSpecial: false,
            requiredPoints: 0
        ),
        GameLevel(
            levelID: 2,
            title: "Countries by Population",
            cards: [
                Card(value: "Canada", correctPosition: 0),
                Card(value: "Russia", correctPosition: 1),
                Card(value: "USA", correctPosition: 2),
                Card(value: "India", correctPosition: 3),
                Card(value: "China", correctPosition: 4)
            ],
            description: "Arrange the countries by population (from smallest to largest).",
            fact: "China has over 1.4 billion people!",
            isSpecial: false,
            requiredPoints: 0
        ),
        GameLevel(
            levelID: 3,
            title: "Colors of the Rainbow",
            cards: [
                Card(value: "Red", correctPosition: 0),
                Card(value: "Orange", correctPosition: 1),
                Card(value: "Yellow", correctPosition: 2),
                Card(value: "Green", correctPosition: 3),
                Card(value: "Blue", correctPosition: 4)
            ],
            description: "Arrange the colors of the rainbow in the correct order.",
            fact: "There are 7 colors in the rainbow, but the human eye can see thousands of shades!",
            isSpecial: false,
            requiredPoints: 0
        ),
        GameLevel(
            levelID: 4,
            title: "Historical Events",
            cards: [
                Card(value: "Invention of the Wheel", correctPosition: 0),
                Card(value: "Writing Appears", correctPosition: 1),
                Card(value: "Pyramids Built", correctPosition: 2),
                Card(value: "Discovery of America", correctPosition: 3),
                Card(value: "First Space Flight", correctPosition: 4)
            ],
            description: "Arrange the events in chronological order.",
            fact: "The first human in space was Yuri Gagarin, 1961.",
            isSpecial: false,
            requiredPoints: 0
        ),
        GameLevel(
            levelID: 5,
            title: "Planets by Distance from the Sun",
            cards: [
                Card(value: "Mercury", correctPosition: 0),
                Card(value: "Venus", correctPosition: 1),
                Card(value: "Earth", correctPosition: 2),
                Card(value: "Mars", correctPosition: 3),
                Card(value: "Jupiter", correctPosition: 4)
            ],
            description: "Arrange the planets by their distance from the Sun.",
            fact: "Jupiter is the largest planet in the Solar System!",
            isSpecial: false,
            requiredPoints: 0
        ),
        GameLevel(
            levelID: 6,
            title: "Numbers Ascending",
            cards: [
                Card(value: "3", correctPosition: 0),
                Card(value: "7", correctPosition: 1),
                Card(value: "12", correctPosition: 2),
                Card(value: "18", correctPosition: 3),
                Card(value: "25", correctPosition: 4)
            ],
            description: "Arrange the numbers in ascending order.",
            fact: "25 is a perfect square (5x5)!",
            isSpecial: false,
            requiredPoints: 0
        ),
        GameLevel(
            levelID: 7,
            title: "Continents by Area",
            cards: [
                Card(value: "Australia", correctPosition: 0),
                Card(value: "Europe", correctPosition: 1),
                Card(value: "Africa", correctPosition: 2),
                Card(value: "North America", correctPosition: 3),
                Card(value: "Asia", correctPosition: 4)
            ],
            description: "Arrange the continents from smallest to largest area.",
            fact: "Asia is the largest continent on Earth!",
            isSpecial: false,
            requiredPoints: 0
        ),
        GameLevel(
            levelID: 8,
            title: "US Presidents Chronologically",
            cards: [
                Card(value: "George Washington", correctPosition: 0),
                Card(value: "Abraham Lincoln", correctPosition: 1),
                Card(value: "Theodore Roosevelt", correctPosition: 2),
                Card(value: "John F. Kennedy", correctPosition: 3),
                Card(value: "Barack Obama", correctPosition: 4)
            ],
            description: "Arrange the US presidents in chronological order.",
            fact: "George Washington was the first US president.",
            isSpecial: false,
            requiredPoints: 0
        ),
        GameLevel(
            levelID: 9,
            title: "Months Alphabetically",
            cards: [
                Card(value: "April", correctPosition: 0),
                Card(value: "August", correctPosition: 1),
                Card(value: "December", correctPosition: 2),
                Card(value: "February", correctPosition: 3),
                Card(value: "January", correctPosition: 4)
            ],
            description: "Arrange the months in alphabetical order.",
            fact: "There are 12 months in a year.",
            isSpecial: false,
            requiredPoints: 0
        ),
        GameLevel(
            levelID: 10,
            title: "Largest Oceans",
            cards: [
                Card(value: "Arctic", correctPosition: 0),
                Card(value: "Indian", correctPosition: 1),
                Card(value: "Atlantic", correctPosition: 2),
                Card(value: "Southern", correctPosition: 3),
                Card(value: "Pacific", correctPosition: 4)
            ],
            description: "Arrange the oceans from smallest to largest.",
            fact: "The Pacific Ocean is the largest and deepest ocean.",
            isSpecial: false,
            requiredPoints: 0
        ),
        GameLevel(
            levelID: 11,
            title: "Famous Painters",
            cards: [
                Card(value: "Leonardo da Vinci", correctPosition: 0),
                Card(value: "Vincent van Gogh", correctPosition: 1),
                Card(value: "Claude Monet", correctPosition: 2),
                Card(value: "Pablo Picasso", correctPosition: 3),
                Card(value: "Salvador Dalí", correctPosition: 4)
            ],
            description: "Arrange the painters by their birth year (oldest to youngest).",
            fact: "Leonardo da Vinci painted the Mona Lisa.",
            isSpecial: false,
            requiredPoints: 0
        ),
        GameLevel(
            levelID: 12,
            title: "Planets by Mass",
            cards: [
                Card(value: "Mercury", correctPosition: 0),
                Card(value: "Mars", correctPosition: 1),
                Card(value: "Venus", correctPosition: 2),
                Card(value: "Earth", correctPosition: 3),
                Card(value: "Jupiter", correctPosition: 4)
            ],
            description: "Arrange the planets by their mass (smallest to largest).",
            fact: "Jupiter is more massive than all other planets combined!",
            isSpecial: false,
            requiredPoints: 0
        ),
        GameLevel(
            levelID: 13,
            title: "Famous Landmarks",
            cards: [
                Card(value: "Eiffel Tower", correctPosition: 0),
                Card(value: "Statue of Liberty", correctPosition: 1),
                Card(value: "Great Wall of China", correctPosition: 2),
                Card(value: "Colosseum", correctPosition: 3),
                Card(value: "Taj Mahal", correctPosition: 4)
            ],
            description: "Arrange the landmarks by their construction date (oldest to newest).",
            fact: "The Great Wall of China is over 13,000 miles long!",
            isSpecial: false,
            requiredPoints: 0
        ),
        GameLevel(
            levelID: 14,
            title: "Sports Alphabetically",
            cards: [
                Card(value: "Baseball", correctPosition: 0),
                Card(value: "Basketball", correctPosition: 1),
                Card(value: "Football", correctPosition: 2),
                Card(value: "Hockey", correctPosition: 3),
                Card(value: "Tennis", correctPosition: 4)
            ],
            description: "Arrange the sports in alphabetical order.",
            fact: "Tennis originated in France in the 12th century.",
            isSpecial: false,
            requiredPoints: 0
        ),
        GameLevel(
            levelID: 15,
            title: "Cities by Population",
            cards: [
                Card(value: "Sydney", correctPosition: 0),
                Card(value: "London", correctPosition: 1),
                Card(value: "New York", correctPosition: 2),
                Card(value: "Tokyo", correctPosition: 3),
                Card(value: "Shanghai", correctPosition: 4)
            ],
            description: "Arrange the cities by population (smallest to largest).",
            fact: "Shanghai is the most populous city in the world.",
            isSpecial: false,
            requiredPoints: 0
        ),
        GameLevel(
            levelID: 16,
            title: "Inventions Chronologically",
            cards: [
                Card(value: "Printing Press", correctPosition: 0),
                Card(value: "Steam Engine", correctPosition: 1),
                Card(value: "Telephone", correctPosition: 2),
                Card(value: "Airplane", correctPosition: 3),
                Card(value: "Internet", correctPosition: 4)
            ],
            description: "Arrange the inventions in chronological order.",
            fact: "The Internet was invented in the late 20th century.",
            isSpecial: false,
            requiredPoints: 0
        ),
        GameLevel(
            levelID: 17,
            title: "Days of the Week",
            cards: [
                Card(value: "Monday", correctPosition: 0),
                Card(value: "Tuesday", correctPosition: 1),
                Card(value: "Wednesday", correctPosition: 2),
                Card(value: "Thursday", correctPosition: 3),
                Card(value: "Friday", correctPosition: 4)
            ],
            description: "Arrange the days of the week in order.",
            fact: "There are 7 days in a week.",
            isSpecial: false,
            requiredPoints: 0
        ),
        GameLevel(
            levelID: 18,
            title: "Tallest Buildings",
            cards: [
                Card(value: "Empire State", correctPosition: 0),
                Card(value: "Eiffel Tower", correctPosition: 1),
                Card(value: "Shanghai Tower", correctPosition: 2),
                Card(value: "Burj Khalifa", correctPosition: 3),
                Card(value: "One World Trade", correctPosition: 4)
            ],
            description: "Arrange the buildings by height (shortest to tallest).",
            fact: "Burj Khalifa is the tallest building in the world.",
            isSpecial: false,
            requiredPoints: 0
        ),
        GameLevel(
            levelID: 19,
            title: "Famous Authors",
            cards: [
                Card(value: "Shakespeare", correctPosition: 0),
                Card(value: "Tolstoy", correctPosition: 1),
                Card(value: "Hemingway", correctPosition: 2),
                Card(value: "Rowling", correctPosition: 3),
                Card(value: "King", correctPosition: 4)
            ],
            description: "Arrange the authors by their birth year (oldest to youngest).",
            fact: "Shakespeare is the most famous playwright in history.",
            isSpecial: false,
            requiredPoints: 0
        ),
        GameLevel(levelID: 100, title: "Super Challenge", cards: [Card(value: "Mercury", correctPosition: 0), Card(value: "Venus", correctPosition: 1), Card(value: "Earth", correctPosition: 2), Card(value: "Mars", correctPosition: 3), Card(value: "Jupiter", correctPosition: 4)], description: "Arrange the planets by their distance from the Sun as fast as you can!", fact: "Jupiter is the largest planet in the Solar System!", isSpecial: true, requiredPoints: 300),
        GameLevel(levelID: 101, title: "Ultimate Order", cards: [Card(value: "Invention of the Wheel", correctPosition: 0), Card(value: "Writing Appears", correctPosition: 1), Card(value: "Pyramids Built", correctPosition: 2), Card(value: "Discovery of America", correctPosition: 3), Card(value: "First Space Flight", correctPosition: 4)], description: "Arrange these events in the perfect order. Only for the best!", fact: "The first human in space was Yuri Gagarin, 1961.", isSpecial: true, requiredPoints: 500)
    ]
} 