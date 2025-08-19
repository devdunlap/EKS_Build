import random
import math
import art
""" Number Guessing Game """

def play_game():
    best_score = None
    while True:
        print(art.logo)
        print("Welcome to the Number Guessing Game!")
        print("I'm thinking of a number between 1 and 100.")
        # Difficulty selection
        difficulty = input("Choose a difficulty. Type 'easy', 'medium', or 'hard': ").lower()
        if difficulty == 'easy':
            max_attempts = 10
        elif difficulty == 'medium':
            max_attempts = 7
        elif difficulty == 'hard':
            max_attempts = 5
        else:
            print("Invalid difficulty. Defaulting to 'hard'.")
            max_attempts = 5

        number_to_guess = random.randint(1, 100)
        attempts = 0
        while attempts < max_attempts:
            try:
                guess = int(input("Make a guess: "))
            except ValueError:
                print("Please enter a valid integer.")
                continue
            attempts += 1
            if guess == number_to_guess:
                print(f"Congratulations! You've guessed the number {number_to_guess} correctly in {attempts} attempts.")
                if best_score is None or attempts < best_score:
                    best_score = attempts
                    print(f"New best score: {best_score} attempts!")
                break
            elif guess < number_to_guess:
                print("Too low.")
                if abs(guess - number_to_guess) <= 5:
                    print("You're very close!")
            else:
                print("Too high.")
                if abs(guess - number_to_guess) <= 5:
                    print("You're very close!")

        if attempts == max_attempts and guess != number_to_guess:
            print(f"Sorry, you've run out of attempts. The number was {number_to_guess}.")

        if best_score:
            print(f"Your best score so far: {best_score} attempts.")
        play_again = input("Do you want to play again? (y/n): ").lower()
        if play_again != 'y':
            print("Thanks for playing! Goodbye.")
            break