from flask import render_template
from flask_app import app


@app.errorhandler(404)
def not_found_error(error):
    return render_template('404.html'), 404


@app.errorhandler(500)
def internal_error(e):
    app.logger.error(f"500 Error - Internal server error: {request.url}")
    return render_template('errors/500.html'), 500