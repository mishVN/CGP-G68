<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Form</title>
    <script src="https://js.stripe.com/v3/"></script>
    <style>
        body {
            background-color: white; /* White background for the page */
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            position: relative;
        }

        h2 {
            color: green; /* Green color for the "Payment Form" header */
            font-size: 24px;
            margin-bottom: 20px;
        }

        #payment-form {
            background-color: #f9f9f9; /* Light background for the form */
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 300px; /* Form width */
            position: relative;
        }

        .input-container {
            margin-bottom: 15px;
        }

        .input-container label {
            font-size: 14px;
            color: #333;
            margin-bottom: 5px;
        }

        .input-container input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }

        #card-element {
            background-color: #ffffff;
            border: 1px solid #ddd;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 10px;
        }

        #card-errors {
            color: red;
            font-size: 12px;
            margin-top: 10px;
        }

        button {
            background-color: green; /* Green button */
            color: white;
            padding: 10px;
            width: 100%;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 10px;
        }

        button:disabled {
            background-color: #ddd; /* Light gray for disabled button */
            cursor: not-allowed;
        }

        button:hover {
            background-color: darkgreen; /* Darker green on hover */
        }

        /* Logo positioning side by side */
        .logo-container {
            display: flex;
            justify-content: center;  /* Center logos horizontally */
            gap: 20px; /* Space between the logos */
            margin-bottom: 15px; /* Add space between logos and the card input */
        }

        .card-logo {
            width: 40px;
            height: 40px;
            cursor: pointer;
        }
    </style>
</head>
<body>

    <div>
        <h2>Payment Form</h2>

        <form id="payment-form">
            
            <!-- Card type selection (Visa/MasterCard) side by side -->
            <div class="logo-container">
                <img src="/download.png" alt="Visa Logo" class="card-logo" id="visa-logo" data-card-type="visa">
                <img src="/download (1).png" alt="MasterCard Logo" class="card-logo" id="mastercard-logo" data-card-type="mastercard">
            </div>
            
            <!-- Card number field -->
            <div class="input-container">
                <label for="card-element">Card Number</label>
                <div id="card-element">
                    <!-- A Stripe Element will be inserted here. -->
                </div>
            </div>
            
            <!-- Card holder's name field -->
            <div class="input-container">
                <label for="holder-name">Card Holder's Name</label>
                <input type="text" id="holder-name" placeholder="Enter card holder's name" required>
            </div>
            
            <!-- Used to display form errors. -->
            <div id="card-errors" role="alert"></div>

            <button type="submit" id="submit">Pay Now</button>
        </form>
    </div>

    <script>
        // Set your publishable key from Stripe
        const stripe = Stripe('your-publishable-key-here'); // Replace with your actual publishable key
        const elements = stripe.elements();
        const cardElement = elements.create('card');
        
        // Mount the Card element to the DOM
        cardElement.mount('#card-element');

        const form = document.getElementById('payment-form');
        const submitButton = document.getElementById('submit');
        const cardErrors = document.getElementById('card-errors');
        const holderNameInput = document.getElementById('holder-name');
        const visaLogo = document.getElementById('visa-logo');
        const mastercardLogo = document.getElementById('mastercard-logo');
        
        let selectedCardType = 'visa'; // Default to Visa

        // Event listener to select card type
        visaLogo.addEventListener('click', () => {
            selectedCardType = 'visa';
            updateCardTypeSelection();
        });

        mastercardLogo.addEventListener('click', () => {
            selectedCardType = 'mastercard';
            updateCardTypeSelection();
        });

        // Function to update card type visual feedback
        function updateCardTypeSelection() {
            if (selectedCardType === 'visa') {
                visaLogo.style.border = '2px solid green';
                mastercardLogo.style.border = '';
            } else {
                mastercardLogo.style.border = '2px solid green';
                visaLogo.style.border = '';
            }
        }

        form.addEventListener('submit', async (event) => {
            event.preventDefault();
            
            // Disable the submit button to prevent multiple clicks
            submitButton.disabled = true;

            // Create a payment method using the card details
            const {token, error} = await stripe.createToken(cardElement);

            if (error) {
                cardErrors.textContent = error.message;
                submitButton.disabled = false; // Re-enable the submit button
            } else {
                // Send the token to your server for further processing
                fetch('/process-payment', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        token: token.id,
                        cardholder_name: holderNameInput.value, // Send cardholder's name to the server
                        card_type: selectedCardType // Send selected card type to the server
                    }),
                })
                .then((response) => response.json())
                .then((data) => {
                    if (data.success) {
                        alert('Payment Successful!');
                    } else {
                        alert('Payment Failed!');
                    }
                })
                .catch((error) => {
                    console.error('Error:', error);
                    alert('An error occurred, please try again.');
                })
                .finally(() => {
                    submitButton.disabled = false; // Re-enable the submit button
                });
            }
        });
    </script>
</body>
</html>