import random
import math
import art
""" Number Guessing Game """

def play_game():
    print(art.logo)
    print("Welcome to the Number Guessing Game!")
    print("I'm thinking of a number between 1 and 100.")
    number_to_guess = random.randint(1, 100)
    attempts = 0
    max_attempts = 5

    while attempts < max_attempts:
        guess = int(input("Make a guess: "))
        attempts += 1
        if guess == number_to_guess:
            print(f"Congratulations! You've guessed the number {number_to_guess} correctly.")
            break
        elif guess < number_to_guess:
            print("Too low.")
        else:
            print("Too high.")

    if attempts == max_attempts:
        print(f"Sorry, you've run out of attempts. The number was {number_to_guess}.")

play_game()