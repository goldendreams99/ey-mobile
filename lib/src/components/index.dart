library employ.widgets;

import 'dart:async';
/// [DART VENDORS]
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:date_format/date_format.dart';
import 'package:employ/app.dart';
import 'package:employ/src/components/customBorder.dart';
import 'package:employ/src/components/flat_button.dart';
import 'package:employ/src/components/outline_button.dart';
import 'package:employ/src/components/raised_button.dart';
import 'package:employ/src/components/vertical_tab_var_view.dart';
import 'package:employ/src/config/application.dart';
import 'package:employ/src/models/chat/message/ticket_chat.dart';
import 'package:employ/src/models/expense/expense.dart';
import 'package:employ/src/models/index.dart';
import 'package:employ/src/models/chat/ticket.dart';
import 'package:employ/src/pages/index.dart';
import 'package:employ/src/providers/calendar/calendar_provider.dart';
import 'package:employ/src/providers/index.dart';
import 'package:employ/src/providers/sign_in_form/sign_in_form_provider.dart';
import 'package:employ/src/providers/sign_in_form/sign_in_form_state.dart';
/// [APP]
import 'package:employ/src/theme/index.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
/// [FLUTTER VENDORS]
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show LengthLimitingTextInputFormatter, SystemUiOverlayStyle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:lottie/lottie.dart';
import 'package:open_filex/open_filex.dart';
/// [VENDORS]
import 'package:path_provider/path_provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:uuid/uuid.dart';
import 'package:localstorage/localstorage.dart';

import '../providers/app/app_provider.dart';

part './awards/box_clipper.dart';
part './awards/diamont_container.dart';
part './awards/people_list.dart';
part './awards/received_tab.dart';
part './biometric_picture_module.dart';
part './biometric_signature_module.dart';
part './change_password_on_bording.dart';
part './chat/chat_item.file.dart';
part './chat/chat_item.image.dart';
part './chat/chat_item.message.dart';
part './chat/text_bar.dart';
part './chip.dart';
part './clipperShadow.dart';
part './custom_app_bar.dart';
part './custom_app_bar.view.dart';
part './dialogs/award_received.dart';
part './dialogs/expense_scanner.dart';
part './dialogs/remove_expense.dart';
/// [Dialogs]
part './dialogs/send_file.dart';
part './dialogs/sign_document_missing_biometric_data.dart';
part './document_item.dart';
part './employ_calendar/day.dart';
part './employ_calendar/index.dart';
part './employ_calendar/month.dart';
part './employ_camera/footer.dart';
part './employ_camera/header.dart';
part './employ_camera/index.dart';
part './employ_expense_camera/footer.dart';
part './employ_expense_camera/header.dart';
part './employ_expense_camera/index.dart';
part './employ_stepper/footer.dart';
part './employ_stepper/header.dart';
/// [CUSTOM FLUTTER COMPONENTS]
part './employ_stepper/index.dart';
part './employ_stepper/step.dart';
part './expense_item.dart';
part './filter_card.dart';
part './fixed_list_item.dart';
part './footer_button.dart';
part './general_camera/footer.dart';
part './general_camera/header.dart';
part './general_camera/index.dart';
/// [LIBRARY PARTS]
part './gradient_canvas.dart';
part './home_on_bording.dart';
part './license_item.dart';
part './loading_dialog.dart';
part './lottie_animation.dart';
part './menu_button.dart';
part './pin_input.dart';
part './profile_text_input.dart';
part './relationship_card.dart';
part './reset_password_on_bording.dart';
part './sign_dialog.dart';
part './sign_in_form.dart';
part './sign_in_form_step_1.dart';
part './sign_in_form_step_2.dart';
part './sign_in_form_step_3.dart';
part './slider_router.dart';
part './text_field.dart';
part './text_field_nonborder.dart';
part './text_field_underline.dart';
part './ticket_item.dart';

part './feed/main_feed.dart';
