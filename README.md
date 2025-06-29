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
    -   - **Elementi Figli (Contenuti):**
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
      <IconButton icon="Icons.search" color="#FFFFFF" size="24" />
      <IconButton icon="Icons.more_vert" color="#FFFFFF" size="24" />
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
        <IconButton icon="Icons.notifications" color="#FFFFFF" size="26" />
        <IconButton icon="Icons.settings" color="#FFFFFF" size="26" />
      </actions>
    </appBar>
    ```
