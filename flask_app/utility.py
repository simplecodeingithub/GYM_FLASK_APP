# utils.py
def get_nutrition_for_plan(plan):
    if plan == 'Basic':
        return "High Protein Diet (3 meals/day)"
    elif plan == 'Gold':
        return "Weight Loss Meal Plan with snacks"
    elif plan == 'Platinum':
        return "Customized Wellness Meal Plan with personal guidance"
    else:
        return "Standard Meal Plan"

def get_benefits_for_plan(plan):
    if plan == 'Basic':
        return ["Gym Access", "Group Classes"]
    elif plan == 'Gold':
        return ["Gym Access", "Group Classes", "Pool Access"]
    elif plan == 'Platinum':
        return ["Gym Access", "Group Classes", "Pool Access", "Personal Trainer", "Access to VIP Workshops"]
    else:
        return ["Basic Gym Access"]
