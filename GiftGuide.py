import tkinter as tk
from PIL import Image, ImageTk
import clips
import configparser

environment = clips.Environment()
environment.load('construct.clp')

config = configparser.ConfigParser()
config.read('Gifts.properties')

def display_question():
    global question_label, answer_buttons, environment, answer_frame, restart_button

    question_label.pack_forget()
    answer_frame.pack_forget()
    restart_button.pack_forget()

    question_label = tk.Label(root, wraplength=300, font=("Comic Sans MS", 12), bg="#f5f5f5")
    question_label.pack(pady=20)

    answer_frame = tk.Frame(root, bg="#ad0728")
    answer_frame.pack(pady=10, fill=None, expand=False)

    restart_button = tk.Button(root, text="Restart", command=restart, font=("Comic Sans MS", 12, "bold"), bg="#ad0728",
                               fg="white", relief="raised", bd=2)
    restart_button.pack(pady=10)

    for widget in answer_frame.winfo_children():
        widget.destroy()

    i = 0
    for fact in environment.facts():
        fact_str = str(fact)
        #print(i, fact_str)
        i = i +1

        fact_parts = fact_str.split(")")
        question = ""
        answers = []
        for part in fact_parts:
            if "display" in part:
                question = part.split("display")[1].strip().strip(" ()\"")
            elif "valid-answers" in part:
                answers = part.split("valid-answers")[1].strip().strip(" ()\"").split(" ")
    #print(question)
    question_text=""
    if question != "none":
        question_text = config['DEFAULT'][question]

    valid_answers = []
    for answer in answers:
        valid_answers.append(config['DEFAULT'][answer])

    if question_text:
        #print(f"Question: {question_text}")
        question_label.config(text=question_text)
        question_label.pack()
    else:
        answer_frame.pack(pady=100, fill=None, expand=False)
        question_label.pack_forget()

    if valid_answers:
        #print(f"Valid answers: {valid_answers}")
        for answer in answers:
            button = tk.Button(answer_frame, text=config['DEFAULT'][answer], command=lambda a=answer: submit_answer(a),
                               font=("Comic Sans MS", 12), bg="#ad0728", fg="white", relief="raised", bd=2,
                               wraplength=400, justify="left", anchor="w")
            button.pack(side="top", fill="x")

def submit_answer(answer):
    global environment

    fact_name = ""
    i = 0
    for fact in environment.facts():
        fact_str = str(fact)
        #print(i, fact_str)
        i = i + 1

        fact_parts = fact_str.split(")")
        for part in fact_parts:
            if "fact-name" in part:
                fact_name = part.split("fact-name")[1].strip().strip(" ()\"")

    #print("XXX", fact_name, answer)
    if fact_name:
        environment.assert_string(f"({fact_name} {answer})")
        print(f"Fact asserted: ({fact_name} {answer})")

    environment.run()
    if any("state final" in str(fact) for fact in environment.facts()):
        final_message = ""
        for fact in environment.facts():
            fact_str = str(fact)
            #print(i, fact_str)

            fact_parts = fact_str.split(")")
            final_message = ""
            for part in fact_parts:
                if "display" in part:
                    final_message = part.split("display")[1].strip().strip(" ()\"")
        final_message = config['DEFAULT'][final_message]
        show_custom_message("Final Decision", final_message)
        restart()
    else:
        display_question()

def show_custom_message(title, message):
    top = tk.Toplevel(root)
    top.title(title)
    top.config(bg="#f5f5f5")

    message_width = 300
    message_height = 100
    line_count = len(message) // 35
    message_height += line_count * 20

    label = tk.Label(top, text=message, font=("Comic Sans MS", 10), padx=10, pady=10, bg="#f5f5f5", wraplength=270)
    label.pack(pady=(10,5))


    button = tk.Button(top, text="OK", command=top.destroy, font=("Comic Sans MS", 12), bg="#ad0728", fg="white",
                       relief="raised", bd=2)
    button.pack(pady=5)

    window_width = message_width
    window_height = message_height
    screen_width = root.winfo_screenwidth()
    screen_height = root.winfo_screenheight()
    position_top = int(screen_height / 2 - window_height / 2)
    position_left = int(screen_width / 2 - window_width / 2)

    top.geometry(f"{window_width}x{window_height}+{position_left}+{position_top}")

    top.grab_set()
    top.focus_set()
    top.wait_window()

def restart():
    global environment
    environment.reset()
    environment.run()
    display_question()


root = tk.Tk()
root.title("Gift Guide")
root.config(bg="#f5f5f5")
root.geometry("800x400")
icon = tk.PhotoImage(file="logo.png")
root.iconphoto(False, icon)

window_width = 800
window_height = 400

screen_width = root.winfo_screenwidth()
screen_height = root.winfo_screenheight()

position_top = int(screen_height / 2 - window_height / 2)
position_left = int(screen_width / 2 - window_width / 2)

root.geometry(f"{window_width}x{window_height}+{position_left}+{position_top}")

background_image = Image.open("background.jpg")
background_image = background_image.resize((800, 400), Image.LANCZOS)
bg_image = ImageTk.PhotoImage(background_image)

background_label = tk.Label(root, image=bg_image)
background_label.place(relwidth=1, relheight=1)

question_label = tk.Label(root, wraplength=300, font=("Comic Sans MS", 12), bg="#f5f5f5")
question_label.pack(pady=20)

answer_frame = tk.Frame(root, bg="#ad0728")
answer_frame.pack(pady=10, fill=None, expand=False)

restart_button = tk.Button(root, text="Restart", command=restart, font=("Comic Sans MS", 12, "bold"), bg="#ad0728",
                           fg="white", relief="raised", bd=2)
restart_button.pack(pady=10)

environment.reset()
environment.run()
display_question()

root.resizable(False, False)
root.mainloop()