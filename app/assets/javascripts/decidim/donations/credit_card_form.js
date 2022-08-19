const creditCardNumberInput = document.querySelector("input.credit-card-number-input");
creditCardNumberInput?.addEventListener("input", () => {
    const input = creditCardNumberInput.value.replace(/\D/g, "").substring(0, 16);
    const parts = input.match(/.{1,4}/g) || [];
    creditCardNumberInput.value = parts.join(" ");
});

const creditCardExpirationInput = document.querySelector("input.credit-card-expiration-input");
creditCardExpirationInput?.addEventListener("input", () => {
    const input = creditCardExpirationInput.value.replace(/\D/g, "").substring(0, 6);
    if (input.length === 1 && (input !== "0" && input !== "1")) {
        creditCardExpirationInput.value = "";
    } else if (input.length === 2 && (parseInt(input) > 12 || parseInt(input) <= 0)) {
        creditCardExpirationInput.value = input.substring(0, 1);
    } else if (input.length > 2) {
        const month = input.substring(0, 2);
        let year = input.substring(2);
        const currentYear = new Date().getFullYear().toString();
        if (year.length === 1 && parseInt(year) < parseInt(currentYear[0])) {
            creditCardExpirationInput.value = month;
        } else {
            for (let i = 1; i < year.length; i++) {
                if (parseInt(year) < parseInt(currentYear.substring(0, i + 1))) {
                    year = year.substring(0, i);
                    break;
                }
            }
            creditCardExpirationInput.value = `${month}/${year}`;
        }
    } else {
        creditCardExpirationInput.value = input;
    }
});

const creditCardCvcInput = document.querySelector("input.credit-card-cvc-input");
creditCardCvcInput?.addEventListener("input", () => {
    creditCardCvcInput.value = creditCardCvcInput.value.replace(/\D/g, "").substring(0, 4);
});
