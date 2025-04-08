<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Payment Form</title>
    <script src="https://js.stripe.com/v3/"></script>
    <style>
        body {
            background-color: white;
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        #payment-form {
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 320px;
        }

        h2 {
            color: green;
            text-align: center;
            margin-bottom: 20px;
        }

        .input-container {
            margin-bottom: 15px;
        }

        .input-container label {
            display: block;
            margin-bottom: 5px;
        }

        .input-container input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        #card-element {
            background-color: white;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        #card-errors {
            color: red;
            font-size: 13px;
            margin-top: 10px;
        }

        button {
            background-color: green;
            color: white;
            padding: 10px;
            width: 100%;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 10px;
        }

        .logo-container {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-bottom: 15px;
        }

        .card-logo {
            width: 40px;
            height: 40px;
            cursor: pointer;
        }

        #payment-request-button {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

<div>
    <h2>Payment Form</h2>
    <form id="payment-form">
        <div id="payment-request-button"></div>

        <div class="logo-container">
            <img src="visa.png" class="card-logo" id="visa-logo" data-card-type="visa">
            <img src="mastercard.png" class="card-logo" id="mastercard-logo" data-card-type="mastercard">
        </div>

        <div class="input-container">
            <label for="holder-name">Card Holder's Name</label>
            <input type="text" id="holder-name" placeholder="Enter card holder's name" required>
        </div>

        <div class="input-container">
            <label for="card-element">Card Number</label>
            <div id="card-element"></div>
        </div>

        <div id="card-errors" role="alert"></div>

        <button type="submit" id="submit">Pay Now</button>
    </form>
</div>

<script>
    const stripe = Stripe('your-publishable-key-here'); // Replace with your key
    const elements = stripe.elements();
    const cardElement = elements.create('card');
    cardElement.mount('#card-element');

    const paymentRequest = stripe.paymentRequest({
        country: 'US',
        currency: 'usd',
        total: {
            label: 'Demo Payment',
            amount: 5000,
        },
        requestPayerName: true,
        requestPayerEmail: true,
    });

    const prButton = elements.create('paymentRequestButton', {
        paymentRequest: paymentRequest,
    });

    paymentRequest.canMakePayment().then(function (result) {
        if (result) {
            prButton.mount('#payment-request-button');
        } else {
            document.getElementById('payment-request-button').style.display = 'none';
        }
    });

    paymentRequest.on('token', function(ev) {
        fetch('PaymentServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                token: ev.token.id,
                cardholder_name: ev.payerName,
                card_type: 'wallet'
            }),
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                ev.complete('success');
                alert('Payment Successful!');
            } else {
                ev.complete('fail');
                alert('Payment Failed!');
            }
        });
    });

    let selectedCardType = 'visa';
    document.getElementById('visa-logo').onclick = () => {
        selectedCardType = 'visa';
        updateLogos();
    };
    document.getElementById('mastercard-logo').onclick = () => {
        selectedCardType = 'mastercard';
        updateLogos();
    };

    function updateLogos() {
        document.getElementById('visa-logo').style.border = selectedCardType === 'visa' ? '2px solid green' : '';
        document.getElementById('mastercard-logo').style.border = selectedCardType === 'mastercard' ? '2px solid green' : '';
    }

    document.getElementById('payment-form').addEventListener('submit', async (event) => {
        event.preventDefault();
        const { token, error } = await stripe.createToken(cardElement);
        const holderName = document.getElementById('holder-name').value;

        if (error) {
            document.getElementById('card-errors').textContent = error.message;
        } else {
            fetch('PaymentServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    token: token.id,
                    cardholder_name: holderName,
                    card_type: selectedCardType
                }),
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    alert('Payment Successful!');
                } else {
                    alert('Payment Failed!');
                }
            });
        }
    });
</script>
</body>
</html>