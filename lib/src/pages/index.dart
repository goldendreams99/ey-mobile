library employ.pages;

/// [DART VENDORS]
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

import 'package:country_code_picker/country_code_picker.dart';
import 'package:employ/src/components/awards/sent_tab.dart';
import 'package:employ/src/components/back_to_exit.dart';
import 'package:employ/src/components/dialogs/bottom_sheet_dialog.dart';
import 'package:employ/src/components/pdf_view.dart';
import 'package:employ/src/helpers/chat.dart';
import 'package:employ/src/helpers/object.dart';
import 'package:employ/src/models/chat/message/ticket_chat.dart';
import 'package:employ/src/models/expense/expense.dart';
import 'package:employ/src/models/chat/ticket.dart';
import 'package:employ/src/providers/app/app_provider.dart';
import 'package:employ/src/providers/app/app_state.dart';
import 'package:employ/src/providers/calendar/calendar.dart';
import 'package:employ/src/providers/calendar/calendar_provider.dart';
import 'package:employ/src/providers/filter/filter_provider.dart';
import 'package:employ/src/providers/menu/menu_provider.dart';
import 'package:employ/src/providers/sign_in_form/sign_in_form_provider.dart';
import 'package:employ/src/types/int.dart';

/// [FLUTTER VENDORS]
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show LengthLimitingTextInputFormatter, SystemUiOverlayStyle;

/// [VENDORS]
import 'package:employ/src/components/flat_button.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart'; // Disabled for iOS build
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:uuid/uuid.dart';
import 'package:localstorage/localstorage.dart';
import 'package:camera/camera.dart';
import 'package:date_format/date_format.dart';
// import 'package:google_maps_webservice/places.dart';  // Removed due to AGP 8.x namespace issue
import 'package:share_plus/share_plus.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:country_codes/country_codes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluro/fluro.dart' as fluro;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:store_redirect/store_redirect.dart';

/// [FIREBASE VENDORS]
import 'package:firebase_database/firebase_database.dart';

/// [APP]
import 'package:employ/app.dart';
import 'package:employ/src/config/application.dart';
import 'package:employ/src/components/index.dart';
import 'package:employ/src/theme/index.dart';
import 'package:employ/src/providers/index.dart';
import 'package:employ/src/models/index.dart';

part './root.dart';

part './login.dart';

part './home.dart';

part './on_bording.dart';

part './forgot_password.dart';

part './award.dart';

part './document.dart';

part './document.view.dart';

part './document.view.fixed.dart';

part './license/calendar_selector.dart';

part './license/step_one.dart';

part './license/step_two.dart';

part './license.dart';

part './license.view.dart';

part './license.view.document.dart';

part './license.view.nondocument.dart';

part './license.add.dart';

part 'expense/expense.dart';

part './expense/expense.view.dart';

part './expense/scanner.dart';

part './expense/calendar_selector.dart';

part './expense/expense_amount_page.dart';

part './ticket.dart';

part './ticket.view.dart';

part './ticket.view.empty.dart';

part './ticket.add.dart';

part './profile.dart';

part './profile/phone_page.dart';

part './filter.dart';

part './select.dart';

part './inbox.dart';

part './bank.dart';

part './update_app.dart';

part './sign/index.dart';

part './sign/pin_page.dart';

part './sign/config.dart';

part './sign/reset_pin.dart';

part './signature_pki.dart';

part './pki_data.dart';

part './signature_biometric.dart';

part './signature_firmar_gob.dart';

part './change_password.dart';

/// [AWARDS]
part './award/award.add.dart';

part './award/received.dart';

part './award/sent.dart';

part './award/step_one.dart';

part './award/step_two.dart';

part './award/step_three.dart';

part './award/created.dart';

/// [DATOS BIOMETRICOS]
part './biometric_data.view.dart';

part './biometric_data/index.dart';

part './biometric_data/upload.dart';

part './biometric_data/step_one.dart';

part './biometric_data/step_two.dart';

part './biometric_data/step_three.dart';

part './biometric_data/step_four.dart';

part './biometric_data/step_five.dart';

part './biometric_data/step_six.dart';

part './biometric_data/signature_pad.dart';

/// [FIXED YPF]
part './YPF/input_data.dart';

part './YPF/income_data_steps/step_one.dart';

part './YPF/income_data_steps/step_two.dart';

part './YPF/income_data_steps/step_three.dart';

part './YPF/income_data_steps/step_four.dart';

part './YPF/income_data_steps/step_five.dart';

part './YPF/income_data_steps/step_six.dart';

part './YPF/leading_request.dart';
