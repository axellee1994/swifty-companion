#!/bin/bash

# Path to Dio Handler file
DIO_HANDLER="lib/core/services/dio_handler.dart"

echo "🚀 Starting Bonus Test: Token Refresh Logic"

# Sabotage the token in the code
echo "🔧 Sabotaging the token in $DIO_HANDLER..."
sed -i "s/options.headers\['Authorization'\] = 'Bearer \$token';/options.headers\['Authorization'\] = 'Bearer \${token}INVALID_STRING';/g" "$DIO_HANDLER"

echo "✅ Token sabotaged! (Added 'INVALID_STRING' to the header)"
echo "--------------------------------------------------------"
echo "INSTRUCTIONS:"
echo "1. The app will launch now."
echo "2. Perform a search for any user."
echo "3. Watch your terminal logs for '🚨 Token expired! Attempting to refresh...'"
echo "4. The search should succeed AFTER the refresh log appears."
echo "--------------------------------------------------------"

# 2. Run the application
flutter run -d linux

# 3. Revert the code after the app is closed
echo "🧹 Reverting $DIO_HANDLER back to original state..."
sed -i "s/options.headers\['Authorization'\] = 'Bearer \${token}INVALID_STRING';/options.headers\['Authorization'\] = 'Bearer \$token';/g" "$DIO_HANDLER"

echo "✨ Test Complete. Code restored."