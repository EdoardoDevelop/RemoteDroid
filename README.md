# remotedroid

Dynamic ui project.

## Tag XML
-   **Widget di Base e Layout:**
    -   `Text`
    -   `Container`
    -   `Column`
    -   `Row`
    -   `Expanded`
    -   `Padding`
    -   `Center`
    -   `Align`
    -   `SizedBox`
    -   `Stack`
    -   `Positioned`
    -   `Card`
    -   `Divider`
    -   `Icon`
    -   `Image`
-   **Widget di Scorrimento e Liste:**
    -   `ListView`
    -   `GridView`
    -   `SingleChildScrollView`
    -   `CustomScrollView`
    -   `Scrollable`
    -   `Scrollbar`
    -   `ScrollConfiguration`
    -   `ScrollNotification`
    -   `ScrollController`
-   **Widget Adattivi e di Overflow:**
    -   `AspectRatio`
    -   `FittedBox`
    -   `FractionallySizedBox`
    -   `LimitedBox`
    -   `Offstage`
    -   `OverflowBox`
    -   `SizedOverflowBox`
    -   `UnconstrainedBox`
    -   `ConstrainedBox`
-   **Widget di Trasformazione ed Effetti:**
    -   `Transform`
    -   `CustomPaint`
    -   `ClipPath`
    -   `ClipRect`
    -   `ClipOval`
    -   `Opacity`
    -   `BackdropFilter`
    -   `DecoratedBox`
    -   `FractionalTranslation`
    -   `RotatedBox`
-   **Widget di Navigazione e Struttura App:**
    -   `Scaffold`
    -   `appBar`
    -   `BottomNavigationBar`
    -   `Drawer`
    -   `TabBar`
    -   `TabBarView`
-   **Widget Interattivi e di Input:**
    -   `RaisedButton` (ora `ElevatedButton`)
    -   `FlatButton` (ora `TextButton`)
    -   `OutlineButton` (ora `OutlinedButton`)
    -   `IconButton`
    -   `FloatingActionButton`
    -   `TextButton` (ripetuto nel codice, ma corretto)
    -   `Slider`
    -   `Switch`
    -   `Checkbox`
    -   `Radio`
    -   `DropdownButton`
    -   `Chip`
    -   `Tooltip`
-   **Widget di Progresso:**
    -   `CircularProgressIndicator`
    -   `LinearProgressIndicator`
-   **Widget di Dialogo e Messaggi:**
    -   `AlertDialog`
    -   `SnackBar`
    -   `BottomSheet`
-   **Widget Animati:**
    -   `AnimatedContainer`
    -   `FadeTransition`
    -   `ScaleTransition`
    -   `SlideTransition`
-   **Widget Speciali:**
    -   `body` (questo non è un widget Flutter standard, ma un tag
        personalizzato che il tuo `WidgetBuilder` interpreta per creare
        un `Container` con specifiche proprietà per il corpo della
        schermata).


## appBar
-   **`AppBar`**
    -   Permette di definire la barra superiore dell'applicazione con titolo, icone e azioni.
    -   **Attributi (Proprietà Dirette):**
    -   `backgroundColor`: Colore di sfondo (es. `#2196F3`, `red`).
    -   `elevation`: Altezza dell'ombra sotto l'AppBar, per un effetto di profondità (es. `4.0`).
    -   `centerTitle`: Allinea il titolo al centro (`true`/`false`).
    -   `toolbarHeight`: Altezza fissa della toolbar (es. `65.0`).
    -   **Elementi Figli (Contenuti):**
    -   **Titolo (`Text`):**
    -   Un tag `Text` con le sue proprietà, posizionato come primo figlio.
    -   Esempio: `<Text text="Mio Titolo" fontSize="20" color="#FFFFFF" />`
    -   **Widget Principale (`leading`):**
      -   Contenitore per un singolo widget a sinistra (es. icona menu, pulsante indietro).
        -   Esempio:
    ```xml
    <leading>
      <Icon icon="Icons.menu" color="#FFFFFF" size="24" />
    </leading>
    ```
    -   **Azioni (`actions`):**
    -   Contenitore per una lista di widget a destra (es. pulsanti icona).
    -   Esempio:
    ```xml
    <actions>
      <IconButton icon="Icons.search" iconColor="#FFFFFF" size="24" onPressed="doNothing" />
      <IconButton icon="Icons.more_vert" iconColor="#FFFFFF" size="24" onPressed="doNothing" />
    </actions>
    ```
    -   **Esempio XML Completo:**
    ```xml
    <appBar backgroundColor="#1E88E5" elevation="8.0" centerTitle="true" toolbarHeight="65.0">
      <Text text="La Mia App Dinamica" fontSize="22" color="#FFFFFF" fontWeight="bold" />
      <leading>
        <Icon icon="Icons.menu" color="#FFFFFF" size="28" />
      </leading>
      <actions>
        <IconButton icon="Icons.notifications" iconColor="#FFFFFF" size="26" onPressed="doNothing" />
        <IconButton icon="Icons.settings" iconColor="#FFFFFF" size="26" onPressed="doNothing" />
      </actions>
    </appBar>
    ```
    
## Actions
-   **Sistema di Azioni Dinamiche della UI**
    -   L'applicazione implementa un robusto sistema di interfaccia utente (UI) dinamica, definita tramite configurazioni XML, permettendo di gestire elementi interattivi e le loro funzionalità direttamente dal markup.
    -   **Come Funzionano le Azioni:**
    -   **`WidgetAction` (Enumerazione Dart)**: Definisce tutte le azioni predefinite e supportate dall'applicazione (e.g., `showAlert`, `navigate`, `openURL`).
    -   **`ActionHandler` (Classe Dart)**: Gestisce l'esecuzione effettiva di ciascuna `WidgetAction`, ricevendo l'azione e opzionalmente un set di parametri.
    -   **Attributi XML `onPressed` e `actionParams`**: Collegano l'elemento UI alla `WidgetAction` e ai suoi parametri.
    -   **L'Attributo `onPressed`**:
    -   Una **stringa** assegnata agli elementi interattivi (es. `IconButton`), deve corrispondere a un valore del tuo `enum WidgetAction`.
    -   Esempio XML: `<IconButton icon="Icons.search" iconColor="#FFFFFF" size="24" onPressed="performSearch" />`
    -   **L'Attributo `actionParams`**:
    -   Una **stringa JSON valida** contenente coppie chiave-valore per i parametri dell'azione.
    -   **Importante: Formattazione JSON nell'XML**: Utilizzare **virgolette singole (`'`)** per l'attributo `actionParams` per scrivere JSON pulito (le virgolette doppie (`"`) all'interno del JSON non richiederanno `&quot;`).
    -   Esempio XML con `actionParams` pulito:
    ```xml
    <IconButton
      icon="Icons.info_outline"
      iconColor="#FFFFFF"
      size="26"
      onPressed="showAlert"
      actionParams='{"title": "Informazione", "message": "Benvenuto nella nostra app!"}'
    />
    ```
    -   **Azioni Disponibili e Loro Parametri:**
    -   **`showAlert`**: Mostra una finestra di dialogo di avviso all'utente.
    -   Parametri `actionParams`:
    -   `title` (String, opzionale): Il titolo del dialogo. Default: "Alert".
    -   `message` (String, opzionale): Il messaggio principale del dialogo. Default: "This is an alert dialog.".
    -   `confirmButtonText` (String, opzionale): Testo per il pulsante di conferma. Default: "OK".
    -   Esempio XML:
    ```xml
    <IconButton onPressed="showAlert" actionParams='{"title": "Attenzione!", "message": "Operazione completata con successo.", "confirmButtonText": "Chiudi"}' />
    ```
    -   **`navigate`**: Naviga a una rotta specificata all'interno dell'applicazione.
    -   Parametri `actionParams`:
    -   `route` (String, **richiesto**): Il nome della rotta a cui navigare (es. `/settings`, `/profile`).
    -   Esempio XML:
    ```xml
    <IconButton onPressed="navigate" actionParams='{"route": "/settingsPage"}' />
    ```
    -   **`updateState`**: Attiva una logica per aggiornare lo stato dell'applicazione.
    -   Parametri `actionParams`: Dipendono dall'implementazione specifica della logica di aggiornamento dello stato (es. `{"data": "nuovo valore"}`).
    -   Esempio XML:
    ```xml
    <IconButton onPressed="updateState" actionParams='{"field": "username", "value": "JohnDoe"}' />
    ```
    -   **`printMessage`**: Stampa un messaggio nella console di debug.
    -   Parametri `actionParams`:
    -   `message` (String, opzionale): Il messaggio da stampare. Default: "Default message".
    -   Esempio XML:
    ```xml
    <IconButton onPressed="printMessage" actionParams='{"message": "Pulsante di debug premuto!"}' />
    ```
    -   **`logEvent`**: Registra un evento, utile per l'integrazione con servizi di analytics.
    -   Parametri `actionParams`:
    -   `event` (String, opzionale): Il nome dell'evento da loggare. Default: "Unknown event".
    -   Possono essere inclusi altri parametri specifici dell'evento.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="logEvent" actionParams='{"event": "button_click_analytics", "button_id": "home_button"}' />
    ```
    -   **`toggleVisibility`**: Alterna la visibilità di un widget specifico.
    -   Parametri `actionParams`:
    -   `widgetId` (String, **richiesto**): L'identificatore del widget la cui visibilità deve essere cambiata.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="toggleVisibility" actionParams='{"widgetId": "myHiddenPanel"}' />
    ```
    -   **`openURL`**: Apre un URL nel browser esterno o un'applicazione di sistema.
    -   Parametri `actionParams`:
    -   `url` (String, **richiesto**): L'URL da aprire.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="openURL" actionParams='{"url": "[https://www.google.com](https://www.google.com)"}' />
    ```
    -   **`shareContent`**: Avvia la finestra di condivisione nativa del sistema per condividere un testo.
    -   Parametri `actionParams`:
    -   `content` (String, opzionale): Il testo da condividere. Default: "Default content".
    -   Esempio XML:
    ```xml
    <IconButton onPressed="shareContent" actionParams='{"content": "Dai un'occhiata a questa fantastica app!"}' />
    ```
    -   **`copyToClipboard`**: Copia il testo specificato negli appunti del dispositivo e mostra una `SnackBar` di conferma.
    -   Parametri `actionParams`:
    -   `text` (String, opzionale): Il testo da copiare. Default: una stringa vuota.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="copyToClipboard" actionParams='{"text": "Testo copiato con successo!"}' />
    ```
    -   **`scanQRCode`**: Attiva la funzionalità di scansione di un codice QR.
    -   Parametri `actionParams`: Nessun parametro specifico richiesto per l'attivazione.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="scanQRCode" />
    ```
    -   **`pickImage`**: Permette all'utente di selezionare un'immagine dalla galleria o di scattarne una con la fotocamera.
    -   Parametri `actionParams`:
    -   `source` (String, opzionale): `"camera"` per la fotocamera, altrimenti default a `gallery`.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="pickImage" actionParams='{"source": "camera"}' />
    ```
    -   **`sendEmail`**: Apre il client di posta predefinito con un'email precompilata.
    -   Parametri `actionParams`:
    -   `email` (String, **richiesto**): L'indirizzo email del destinatario.
    -   `subject` (String, opzionale): L'oggetto dell'email.
    -   `body` (String, opzionale): Il corpo del messaggio.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="sendEmail" actionParams='{"email": "supporto@example.com", "subject": "Richiesta di supporto"}' />
    ```
    -   **`makePhoneCall`**: Avvia una chiamata telefonica al numero specificato.
    -   Parametri `actionParams`:
    -   `phoneNumber` (String, **richiesto**): Il numero di telefono da chiamare.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="makePhoneCall" actionParams='{"phoneNumber": "+39123456789"}' />
    ```
    -   **`showSnackBar`**: Mostra una `SnackBar` (un breve messaggio temporaneo) nella parte inferiore dello schermo.
    -   Parametri `actionParams`:
    -   `message` (String, opzionale): Il messaggio da mostrare. Default: "Default SnackBar message".
    -   Esempio XML:
    ```xml
    <IconButton onPressed="showSnackBar" actionParams='{"message": "Dati salvati con successo!"}' />
    ```
    -   **`launchMap`**: Apre l'applicazione mappe predefinita alle coordinate specificate.
    -   Parametri `actionParams`:
    -   `latitude` (Numero, **richiesto**): La latitudine.
    -   `longitude` (Numero, **richiesto**): La longitudine.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="launchMap" actionParams='{"latitude": 41.8902, "longitude": 12.4922}' />
    ```
    -   **`openWebView`**: Apre una pagina web all'interno di una WebView nell'app.
    -   Parametri `actionParams`:
    -   `url` (String, **richiesto**): L'URL da caricare.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="openWebView" actionParams='{"url": "[https://www.google.it/privacy](https://www.google.it/privacy)"}' />
    ```
    -   **`refreshData`**: Attiva un meccanismo per ricaricare o aggiornare i dati nell'applicazione.
    -   Parametri `actionParams`: Dipendono dall'implementazione (es. `{"dataType": "prodotti"}`).
    -   Esempio XML:
    ```xml
    <IconButton onPressed="refreshData" actionParams='{"source": "remote"}' />
    ```
    -   **`submitForm`**: Gestisce l'invio di dati di un form.
    -   Parametri `actionParams`: Tipicamente i dati del form (es. `{"formId": "loginForm", "data": {"user": "test"}}`).
    -   Esempio XML:
    ```xml
    <IconButton onPressed="submitForm" actionParams='{"formId": "contactForm"}' />
    ```
    -   **`validateInput`**: Attiva la logica di validazione per specifici campi di input.
    -   Parametri `actionParams`:
    -   `field` (String, opzionale): Il nome del campo da validare.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="validateInput" actionParams='{"field": "emailInput"}' />
    ```
    -   **`showDatePicker`**: Mostra un selettore di data.
    -   Parametri `actionParams`:
    -   `initialDate` (String, opzionale): Data iniziale in formato "YYYY-MM-DD".
    -   Esempio XML:
    ```xml
    <IconButton onPressed="showDatePicker" actionParams='{"initialDate": "2025-01-15"}' />
    ```
    -   **`showTimePicker`**: Mostra un selettore di ora.
    -   Parametri `actionParams`:
    -   `initialTime` (String, opzionale): Ora iniziale in formato "HH:MM".
    -   Esempio XML:
    ```xml
    <IconButton onPressed="showTimePicker" actionParams='{"initialTime": "09:00"}' />
    ```
    -   **`toggleTheme`**: Alterna il tema dell'applicazione (es. chiaro/scuro).
    -   Parametri `actionParams`: Nessun parametro specifico.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="toggleTheme" />
    ```
    -   **`toggleLanguage`**: Cambia la lingua dell'interfaccia utente.
    -   Parametri `actionParams`:
    -   `languageCode` (String, opzionale): Il codice della lingua (es. `"en"`, `"it"`, `"es"`).
    -   Esempio XML:
    ```xml
    <IconButton onPressed="toggleLanguage" actionParams='{"languageCode": "fr"}' />
    ```
    -   **`downloadFile`**: Avvia il download di un file da un URL.
    -   Parametri `actionParams`:
    -   `url` (String, **richiesto**): L'URL del file.
    -   `fileName` (String, opzionale): Il nome con cui salvare il file.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="downloadFile" actionParams='{"url": "[https://example.com/report.pdf](https://example.com/report.pdf)", "fileName": "rapporto_2024.pdf"}' />
    ```
    -   **`uploadFile`**: Attiva la selezione e il caricamento di un file.
    -   Parametri `actionParams`: Nessun parametro specifico.
    * Esempio XML:
    ```xml
    <IconButton onPressed="uploadFile" />
    ```
    -   **`startTimer`**: Avvia un timer.
    -   Parametri `actionParams`:
    -   `duration` (int, opzionale): Durata in secondi.
    -   `timerId` (String, opzionale): ID per identificare il timer.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="startTimer" actionParams='{"duration": 300, "timerId": "session_timer"}' />
    ```
    -   **`stopTimer`**: Ferma un timer attivo.
    -   Parametri `actionParams`:
    -   `timerId` (String, opzionale): ID del timer da fermare.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="stopTimer" actionParams='{"timerId": "session_timer"}' />
    ```
    -   **`resetTimer`**: Reimposta un timer al suo stato iniziale.
    -   Parametri `actionParams`:
    -   `timerId` (String, opzionale): ID del timer da resettare.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="resetTimer" actionParams='{"timerId": "session_timer"}' />
    ```
    -   **`incrementCounter`**: Incrementa un contatore numerico.
    -   Parametri `actionParams`:
    -   `counterId` (String, opzionale): ID del contatore.
    -   `value` (int, opzionale): Valore di incremento. Default: 1.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="incrementCounter" actionParams='{"counterId": "item_count"}' />
    ```
    -   **`decrementCounter`**: Decrementa un contatore numerico.
    -   Parametri `actionParams`:
    -   `counterId` (String, opzionale): ID del contatore.
    -   `value` (int, opzionale): Valore di decremento. Default: 1.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="decrementCounter" actionParams='{"counterId": "item_count", "value": 5}' />
    ```
    -   **`toggleSwitch`**: Alterna lo stato di un interruttore (es. On/Off).
    -   Parametri `actionParams`:
    -   `switchId` (String, **richiesto**): ID dell'interruttore.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="toggleSwitch" actionParams='{"switchId": "darkModeToggle"}' />
    ```
    -   **`openSettings`**: Apre le impostazioni dell'app o del sistema.
    -   Parametri `actionParams`: Nessun parametro specifico.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="openSettings" />
    ```
    -   **`logout`**: Esegue l'operazione di logout dell'utente.
    -   Parametri `actionParams`: Nessun parametro specifico.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="logout" />
    ```
    -   **`deleteItem`**: Attiva la logica per eliminare un elemento.
    -   Parametri `actionParams`:
    -   `itemId` (String, **richiesto**): ID dell'elemento da eliminare.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="deleteItem" actionParams='{"itemId": "user_profile_123"}' />
    ```
    -   **`archiveItem`**: Archivia un elemento.
    -   Parametri `actionParams`:
    -   `itemId` (String, **richiesto**): ID dell'elemento da archiviare.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="archiveItem" actionParams='{"itemId": "old_message_456"}' />
    ```
    -   **`favoriteItem`**: Marca un elemento come preferito.
    -   Parametri `actionParams`:
    -   `itemId` (String, **richiesto**): ID dell'elemento da favorire.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="favoriteItem" actionParams='{"itemId": "photo_789"}' />
    ```
    -   **`unfavoriteItem`**: Rimuove un elemento dai preferiti.
    -   Parametri `actionParams`:
    -   `itemId` (String, **richiesto**): ID dell'elemento da sfavorire.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="unfavoriteItem" actionParams='{"itemId": "photo_789"}' />
    ```
    -   **`rateApp`**: Chiede all'utente di valutare l'app.
    -   Parametri `actionParams`: Nessun parametro specifico.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="rateApp" />
    ```
    -   **`contactSupport`**: Apre un canale per contattare il supporto.
    -   Parametri `actionParams`: Possono includere `{"method": "email"}` o `{"method": "chat"}`.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="contactSupport" actionParams='{"method": "chat"}' />
    ```
    -   **`bookmarkPage`**: Aggiunge la pagina corrente ai segnalibri.
    -   Parametri `actionParams`:
    -   `pageId` (String, **richiesto**): ID della pagina.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="bookmarkPage" actionParams='{"pageId": "article_abc"}' />
    ```
    -   **`unbookmarkPage`**: Rimuove la pagina corrente dai segnalibri.
    -   Parametri `actionParams`:
    -   `pageId` (String, **richiesto**): ID della pagina.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="unbookmarkPage" actionParams='{"pageId": "article_abc"}' />
    ```
    -   **`shareLocation`**: Chiede il permesso e condivide la posizione attuale.
    -   Parametri `actionParams`: Possono includere `{"accuracy": "high"}`.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="shareLocation" />
    ```
    -   **`toggleSound`**: Alterna l'attivazione/disattivazione dei suoni nell'app.
    -   Parametri `actionParams`: Nessun parametro specifico.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="toggleSound" />
    ```
    -   **`toggleNotifications`**: Alterna l'attivazione/disattivazione delle notifiche dell'app.
    -   Parametri `actionParams`: Nessun parametro specifico.
    -   Esempio XML:
    ```xml
    <IconButton onPressed="toggleNotifications" />
    ```
    -   **`showModalBottomSheet`**: Mostra un modal bottom sheet personalizzato.
    -   Parametri `actionParams`: Variabili a seconda del contenuto del bottom sheet (es. `{"message": "Dettagli aggiuntivi"}`).
    -   Esempio XML:
    ```xml
    <IconButton onPressed="showModalBottomSheet" actionParams='{"message": "Contenuto del Bottom Sheet!"}' />
    ```
    -   **`closeModal`**: Chiude il modal attualmente aperto (bottom sheet, dialog, etc.).
    -   Parametri `actionParams`: Nessun parametro specifico.
    * Esempio XML:
    ```xml
    <IconButton onPressed="closeModal" />
    ```