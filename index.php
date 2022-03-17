<?php
require __DIR__ . '/vendor/autoload.php';
require_once __DIR__ . '/scripts/database.php';
require_once __DIR__ . '/scripts/helpers.php';

$database = connect_to_database();
?>

<html lang="de" xmlns="http://www.w3.org/1999/html">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="Kajak Verleihsystem des AStA der HTWG Konstanz">
    <link rel="stylesheet" href="css/custom.css">
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <title>Kajak Verleihsystem von Coolen Typen</title>
</head>
<body>
<div id="booking" class="section">
    <div class="section-center">
        <div class="booking-cta">
            <a href="index.php" class="link-primary text-decoration-none">
                <h1>
                    Powered by AStA HTWG
                </h1>
            </a>
        </div>
        <div class="container">
            <div class="row">
                <?php
                if ($_SERVER['REQUEST_METHOD'] === 'POST') {
                    $name = clean_string($_POST['name']);
                    $email = clean_string($_POST['email']);
                    $mobile = clean_string($_POST['mobile']);
                    $date = clean_string($_POST['date']);
                    $timeslots = clean_array($_POST['timeslots']);

                    $connection = connect_to_database();
                    prepare_reservation_table($connection);
                    insert_reservation($connection, $name, $email, $mobile, $date, $timeslots);

                } else {
                // configs
                // all weekdays in german
                $newLocal = setlocale(LC_ALL, 'de_DE', 'de_DE.UTF-8');
                $weekdays = array("Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag");
                // start date is today
                $date = date_create();
                // add two days to start date
                $min_day = 3;
                date_add($date, new DateInterval("P${min_day}D"));
                // max days for calendar
                $max_days = 14;
                // timeslots
                $timeslots = array("9:00 - 13:00", "13:00 - 18:00");
                ?>
                <div class="col-md-6">
                    <div class="booking-form">
                        <form action="index.php" method="post" class="needs-validation">
                            <div class="form-group my-2">
                                <label class="form-label">
                                    Name
                                    <input name="name" type="text" placeholder="Max Musterfrau"
                                           class="form-control"
                                           required>
                                </label>
                            </div>

                            <div class="row my-2">
                                <div class="col-sm-6">
                                    <label class="form-label">
                                        E-Mail
                                        <input name="email" type="email" placeholder="ma391mus@htwg-konstanz.de"
                                               class="form-control"
                                               required>
                                    </label>
                                </div>

                                <div class="col-sm-6">
                                    <label class="form-label">
                                        Telefonnummer
                                        <input name="mobile" type="tel" placeholder="+49 (0) 123 456789"
                                               class="form-control"
                                               required>
                                    </label>
                                </div>
                            </div>

                            <div class="row my-2">
                                <div class="col-sm-6">
                                    <!-- select dates -->
                                    <div class="form-group">
                                        <label class="form-label">
                                            Datum
                                            <select name="date" class="form-select" required>
                                                <?php for ($day = 0; $day < $max_days; $day++) {
                                                    $weekday = (int)$date->format('w');
                                                    if ($weekday !== 0 && $weekday !== 6) { ?>
                                                        <option value="<?php echo $date->format('l d.m.Y') ?>">
                                                            <?php echo $weekdays[$weekday] . ' ' . $date->format('d.m.Y') ?>
                                                        </option>
                                                        <?php
                                                    }
                                                    date_add($date, new DateInterval('P1D'));
                                                } ?>
                                            </select>
                                        </label>
                                    </div>
                                </div>

                                <div class="col-sm-6">
                                    <b>Zeitslots</b><br>
                                    <!-- time slots -->
                                    <?php foreach ($timeslots as $timeslot) { ?>
                                        <label class="form-check-label">
                                            <input type="checkbox" name="timeslots[]"
                                                   value="<?php echo $timeslot ?>"
                                                   class="form-check-input">
                                            <?php echo $timeslot ?>
                                        </label><br>
                                    <?php } ?>
                                </div>
                            </div>

                            <div class="col-sm-6">
                                <input type="submit" value="Anfrage senden" class="btn btn-primary"/>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="booking-cta">
                        <h2>Reserviere Kajaks</h2>
                        <p>
                            Wir bieten dir die Möglichkeit, kostenlos Kajaks zu reservieren.
                            Bitte fülle das Formular aus, damit wir überprüfen können, ob an deinem gewünschten Datum
                            und Zeit Kajaks frei sind.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<?php } ?>
</body>
</html>
