#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 440 "Approvals Mgt Notification"
{
    Permissions = TableData "Overdue Approval Entry"=i;

    trigger OnRun()
    begin
    end;

    var
        Text001: label 'Sales %1';
        Text002: label 'Purchase %1';
        Text003: label 'requires your approval.';
        Text004: label 'To view your documents for approval, please use the following link:';
        Text005: label 'Customer';
        Text007: label 'Microsoft Dynamics NAV: %1 Mail';
        Text008: label 'Approval';
        Text009: label 'Cancellation';
        Text010: label 'Rejection';
        Text011: label 'Delegation';
        Text012: label 'Overdue Approvals';
        Text013: label 'Microsoft Dynamics NAV Document Approval System';
        Text014: label 'has been cancelled.';
        Text015: label 'To view the cancelled document, please use the following link:';
        Text016: label 'has been rejected.';
        Text017: label 'To view the rejected document, please use the following link:';
        Text018: label 'Vendor';
        Text020: label 'has been delegated.';
        Text021: label 'To view the delegated document, please use the following link:';
        Text022: label 'Overdue approval';
        Text030: label 'Not yet overdue';
        Text033: label 'Rejection comments:';
        Text040: label 'You must import an Approval Template in Approval Setup.';
        Text041: label 'You must import an Overdue Approval Template in Approval Setup.';
        Text042: label 'Available Credit Limit (LCY)';
        Text043: label 'Request Amount (LCY)';
        AppSetup: Record UnknownRecord452;
        SMTP: Codeunit "SMTP Mail";
        TemplateFile: File;
        SenderName: Text[100];
        SenderAddress: Text[100];
        Recipient: Text[100];
        Subject: Text[100];
        Body: Text[1024];
        InStreamTemplate: InStream;
        InSReadChar: Text[1];
        CharNo: Text[4];
        I: Integer;
        FromUser: Text[100];
        MailCreated: Boolean;
        calledFrom_Var: Integer;
        HRMLeaveRequisition: Record UnknownRecord61125;


    procedure SendSalesApprovalsMail(SalesHeader: Record "Sales Header";ApprovalEntry: Record "Approval Entry")
    begin
        SetTemplate(ApprovalEntry);
        Subject := StrSubstNo(Text007,Text008);
        Body := Text013;

        SMTP.CreateMessage(SenderName,SenderAddress,Recipient,Subject,Body,true);
        Body := '';

        while InStreamTemplate.eos() = false do begin
          InStreamTemplate.ReadText(InSReadChar,1);
          if InSReadChar = '%' then begin
            SMTP.AppendBody(Body);
            Body := InSReadChar;
            if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
            if (InSReadChar >= '0') and (InSReadChar <= '9') then begin
              Body := Body + '1';
              CharNo := InSReadChar;
              while (InSReadChar >= '0') and (InSReadChar <= '9') do begin
                if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
                if (InSReadChar >= '0') and (InSReadChar <= '9') then
                  CharNo := CharNo + InSReadChar;
              end;
            end else
              Body := Body + InSReadChar;
            FillSalesTemplate(Body,CharNo,SalesHeader,ApprovalEntry,0);
            SMTP.AppendBody(Body);
            Body := InSReadChar;
          end else begin
            Body := Body + InSReadChar;
            I := I + 1;
            if I = 500 then begin
              SMTP.AppendBody(Body);
              Body := '';
              I := 0;
            end;
          end;
        end;
        SMTP.AppendBody(Body);
        SMTP.Send;
    end;


    procedure SendPurchaseApprovalsMail(PurchaseHeader: Record "Purchase Header";ApprovalEntry: Record "Approval Entry")
    begin
        SetTemplate(ApprovalEntry);
        Subject := StrSubstNo(Text007,Text008);
        Body := Text013;

        SMTP.CreateMessage(SenderName,SenderAddress,Recipient,Subject,Body,true);
        Body := '';

        while InStreamTemplate.eos() = false do begin
          InStreamTemplate.ReadText(InSReadChar,1);
          if InSReadChar = '%' then begin
            SMTP.AppendBody(Body);
            Body := InSReadChar;
            if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
            if (InSReadChar >= '0') and (InSReadChar <= '9') then begin
              Body := Body + '1';
              CharNo := InSReadChar;
              while (InSReadChar >= '0') and (InSReadChar <= '9') do begin
                if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
                if (InSReadChar >= '0') and (InSReadChar <= '9') then
                  CharNo := CharNo + InSReadChar;
              end;
            end else
              Body := Body + InSReadChar;
            FillPurchaseTemplate(Body,CharNo,PurchaseHeader,ApprovalEntry,0);
            SMTP.AppendBody(Body);
            Body := InSReadChar;
          end else begin
            Body := Body + InSReadChar;
            I := I + 1;
            if I = 500 then begin
              SMTP.AppendBody(Body);
              Body := '';
              I := 0;
            end;
          end;
        end;
        SMTP.AppendBody(Body);
        SMTP.Send;
    end;


    procedure SendSalesCancellationsMail(SalesHeader: Record "Sales Header";ApprovalEntry: Record "Approval Entry")
    begin
        if MailCreated then begin
          GetEmailAddress(ApprovalEntry);
          if Recipient <> SenderAddress then
            SMTP.AddCC(Recipient);
        end else begin
          SetTemplate(ApprovalEntry);
          Subject := StrSubstNo(Text007,Text009);
          Body := Text013;

          SMTP.CreateMessage(SenderName,FromUser,SenderAddress,Subject,Body,true);
          if Recipient <> SenderAddress then
            SMTP.AddCC(Recipient);

          Body := '';

          while InStreamTemplate.eos() = false do begin
            InStreamTemplate.ReadText(InSReadChar,1);
            if InSReadChar = '%' then begin
              SMTP.AppendBody(Body);
              Body := InSReadChar;
              if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
              if (InSReadChar >= '0') and (InSReadChar <= '9') then begin
                Body := Body + '1';
                CharNo := InSReadChar;
                while (InSReadChar >= '0') and (InSReadChar <= '9') do begin
                  if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
                  if (InSReadChar >= '0') and (InSReadChar <= '9') then
                    CharNo := CharNo + InSReadChar;
                end;
              end else
                Body := Body + InSReadChar;
              FillSalesTemplate(Body,CharNo,SalesHeader,ApprovalEntry,1);
              SMTP.AppendBody(Body);
              Body := InSReadChar;
            end else begin
              Body := Body + InSReadChar;
              I := I + 1;
              if I = 500 then begin
                SMTP.AppendBody(Body);
                Body := '';
                I := 0;
              end;
            end;
          end;
          SMTP.AppendBody(Body);
          MailCreated := true;
        end;
    end;


    procedure SendPurchaseCancellationsMail(PurchaseHeader: Record "Purchase Header";ApprovalEntry: Record "Approval Entry")
    begin
        if MailCreated then begin
          GetEmailAddress(ApprovalEntry);
          if Recipient <> SenderAddress then
            SMTP.AddCC(Recipient);
        end else begin
          SetTemplate(ApprovalEntry);
          Subject := StrSubstNo(Text007,Text009);
          Body := Text013;

          SMTP.CreateMessage(SenderName,FromUser,SenderAddress,Subject,Body,true);
          if Recipient <> SenderAddress then
            SMTP.AddCC(Recipient);
          Body := '';

          while InStreamTemplate.eos() = false do begin
            InStreamTemplate.ReadText(InSReadChar,1);
            if InSReadChar = '%' then begin
              SMTP.AppendBody(Body);
              Body := InSReadChar;
              if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
              if (InSReadChar >= '0') and (InSReadChar <= '9') then begin
                Body := Body + '1';
                CharNo := InSReadChar;
                while (InSReadChar >= '0') and (InSReadChar <= '9') do begin
                  if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
                  if (InSReadChar >= '0') and (InSReadChar <= '9') then
                    CharNo := CharNo + InSReadChar;
                end;
              end else
                Body := Body + InSReadChar;
              FillPurchaseTemplate(Body,CharNo,PurchaseHeader,ApprovalEntry,1);
              SMTP.AppendBody(Body);
              Body := InSReadChar;
            end else begin
              Body := Body + InSReadChar;
              I := I + 1;
              if I = 500 then begin
                SMTP.AppendBody(Body);
                Body := '';
                I := 0;
              end;
            end;
          end;
          SMTP.AppendBody(Body);
          MailCreated := true;
        end;
    end;


    procedure SendSalesRejectionsMail(SalesHeader: Record "Sales Header";ApprovalEntry: Record "Approval Entry")
    var
        AppCommentLine: Record "Approval Comment Line";
    begin
        if MailCreated then begin
          GetEmailAddress(ApprovalEntry);
          if Recipient <> SenderAddress then
            SMTP.AddCC(Recipient);
        end else begin
          SetTemplate(ApprovalEntry);
          Subject := StrSubstNo(Text007,Text010);
          Body := Text013;

          SMTP.CreateMessage(SenderName,FromUser,SenderAddress,Subject,Body,true);
          SMTP.AddCC(Recipient);
          Body := '';

          while InStreamTemplate.eos() = false do begin
            InStreamTemplate.ReadText(InSReadChar,1);
            if InSReadChar = '%' then begin
              SMTP.AppendBody(Body);
              Body := InSReadChar;
              if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
              if (InSReadChar >= '0') and (InSReadChar <= '9') then begin
                Body := Body + '1';
                CharNo := InSReadChar;
                while (InSReadChar >= '0') and (InSReadChar <= '9') do begin
                  if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
                  if (InSReadChar >= '0') and (InSReadChar <= '9') then
                    CharNo := CharNo + InSReadChar;
                end;
              end else
                Body := Body + InSReadChar;
              FillSalesTemplate(Body,CharNo,SalesHeader,ApprovalEntry,2);
              SMTP.AppendBody(Body);
              Body := InSReadChar;
            end else begin
              Body := Body + InSReadChar;
              I := I + 1;
              if I = 500 then begin
                SMTP.AppendBody(Body);
                Body := '';
                I := 0;
              end;
            end;
          end;
          SMTP.AppendBody(Body);

          // Append Comment Lines
          ApprovalEntry.CalcFields(Comment);
          if ApprovalEntry.Comment then begin
            AppCommentLine.SetCurrentkey("Table ID","Document Type","Document No.");
            AppCommentLine.SetRange("Table ID",ApprovalEntry."Table ID");
            AppCommentLine.SetRange("Document Type",ApprovalEntry."Document Type");
            AppCommentLine.SetRange("Document No.",ApprovalEntry."Document No.");
            if AppCommentLine.Find('-') then begin
              Body := StrSubstNo('<p class="MsoNormal"><font face="Arial size 2"><b>%1</b></font></p>',Text033);
              SMTP.AppendBody(Body);
              repeat
                BuildCommentLine(AppCommentLine);
              until AppCommentLine.Next = 0;
            end;
          end;
          MailCreated := true;
        end;
    end;


    procedure SendPurchaseRejectionsMail(PurchaseHeader: Record "Purchase Header";ApprovalEntry: Record "Approval Entry")
    var
        AppCommentLine: Record "Approval Comment Line";
    begin
        if MailCreated then begin
          GetEmailAddress(ApprovalEntry);
          if Recipient <> SenderAddress then
            SMTP.AddCC(Recipient);
        end else begin
          SetTemplate(ApprovalEntry);
          Subject := StrSubstNo(Text007,Text010);
          Body := Text013;

          SMTP.CreateMessage(SenderName,FromUser,SenderAddress,Subject,Body,true);
          SMTP.AddCC(Recipient);
          Body := '';

          while InStreamTemplate.eos() = false do begin
            InStreamTemplate.ReadText(InSReadChar,1);
            if InSReadChar = '%' then begin
              SMTP.AppendBody(Body);
              Body := InSReadChar;
              if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
              if (InSReadChar >= '0') and (InSReadChar <= '9') then begin
                Body := Body + '1';
                CharNo := InSReadChar;
                while (InSReadChar >= '0') and (InSReadChar <= '9') do begin
                  if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
                  if (InSReadChar >= '0') and (InSReadChar <= '9') then
                    CharNo := CharNo + InSReadChar;
                end;
              end else
                Body := Body + InSReadChar;
              FillPurchaseTemplate(Body,CharNo,PurchaseHeader,ApprovalEntry,2);
              SMTP.AppendBody(Body);
              Body := InSReadChar;
            end else begin
              Body := Body + InSReadChar;
              I := I + 1;
              if I = 500 then begin
                SMTP.AppendBody(Body);
                Body := '';
                I := 0;
              end;
            end;
          end;
          SMTP.AppendBody(Body);

          // Append Comment Lines
          ApprovalEntry.CalcFields(Comment);
          if ApprovalEntry.Comment then begin
            AppCommentLine.SetCurrentkey("Table ID","Document Type","Document No.");
            AppCommentLine.SetRange("Table ID",ApprovalEntry."Table ID");
            AppCommentLine.SetRange("Document Type",ApprovalEntry."Document Type");
            AppCommentLine.SetRange("Document No.",ApprovalEntry."Document No.");
            if AppCommentLine.Find('-') then begin
              Body := StrSubstNo('<p class="MsoNormal"><font face="Arial size 2"><b>%1</b></font></p>',
                  Text033);
              SMTP.AppendBody(Body);
              repeat
                BuildCommentLine(AppCommentLine);
              until AppCommentLine.Next = 0;
            end;
          end;

          MailCreated := true;
        end;
    end;


    procedure SendSalesDelegationsMail(SalesHeader: Record "Sales Header";ApprovalEntry: Record "Approval Entry")
    begin
        SetTemplate(ApprovalEntry);
        Subject := StrSubstNo(Text007,Text011);
        Body := Text013;

        SMTP.CreateMessage(SenderName,FromUser,Recipient,Subject,Body,true);
        SMTP.AddCC(SenderAddress);
        Body := '';

        while InStreamTemplate.eos() = false do begin
          InStreamTemplate.ReadText(InSReadChar,1);
          if InSReadChar = '%' then begin
            SMTP.AppendBody(Body);
            Body := InSReadChar;
            if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
            if (InSReadChar >= '0') and (InSReadChar <= '9') then begin
              Body := Body + '1';
              CharNo := InSReadChar;
              while (InSReadChar >= '0') and (InSReadChar <= '9') do begin
                if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
                if (InSReadChar >= '0') and (InSReadChar <= '9') then
                  CharNo := CharNo + InSReadChar;
              end;
            end else
              Body := Body + InSReadChar;
            FillSalesTemplate(Body,CharNo,SalesHeader,ApprovalEntry,3);
            SMTP.AppendBody(Body);
            Body := InSReadChar;
          end else begin
            Body := Body + InSReadChar;
            I := I + 1;
            if I = 500 then begin
              SMTP.AppendBody(Body);
              Body := '';
              I := 0;
            end;
          end;
        end;
        SMTP.AppendBody(Body);
        SMTP.Send;
    end;


    procedure SendPurchaseDelegationsMail(PurchaseHeader: Record "Purchase Header";ApprovalEntry: Record "Approval Entry")
    begin
        SetTemplate(ApprovalEntry);
        Subject := StrSubstNo(Text007,Text011);
        Body := Text013;

        SMTP.CreateMessage(SenderName,FromUser,Recipient,Subject,Body,true);
        SMTP.AddCC(SenderAddress);
        Body := '';

        while InStreamTemplate.eos() = false do begin
          InStreamTemplate.ReadText(InSReadChar,1);
          if InSReadChar = '%' then begin
            SMTP.AppendBody(Body);
            Body := InSReadChar;
            if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
            if (InSReadChar >= '0') and (InSReadChar <= '9') then begin
              Body := Body + '1';
              CharNo := InSReadChar;
              while (InSReadChar >= '0') and (InSReadChar <= '9') do begin
                if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
                if (InSReadChar >= '0') and (InSReadChar <= '9') then
                  CharNo := CharNo + InSReadChar;
              end;
            end else
              Body := Body + InSReadChar;
            FillPurchaseTemplate(Body,CharNo,PurchaseHeader,ApprovalEntry,3);
            SMTP.AppendBody(Body);
            Body := InSReadChar;
          end else begin
            Body := Body + InSReadChar;
            I := I + 1;
            if I = 500 then begin
              SMTP.AppendBody(Body);
              Body := '';
              I := 0;
            end;
          end;
        end;
        SMTP.AppendBody(Body);
        SMTP.Send;
    end;


    procedure SendOverdueApprovalsMail(Reciever: Text[100];var AppEntriesNotDue: Record "Approval Entry";var AppEntriesDue: Record "Approval Entry")
    var
        AppSetUp: Record UnknownRecord452;
        UserSetup: Record "User Setup";
        QtyAppEntries: Integer;
        QytAppEntDue: Integer;
    begin
        SetOverdueTemplate;
        AppSetUp.Get;
        AppSetUp.TestField("Approval Administrator");
        UserSetup.Get(AppSetUp."Approval Administrator");
        UserSetup.TestField("E-Mail");
        SenderAddress := UserSetup."E-Mail";
        Recipient := Reciever;
        Subject := StrSubstNo(Text007,Text012);
        Body := Text013;

        QtyAppEntries := AppEntriesNotDue.Count;
        QytAppEntDue := AppEntriesDue.Count;

        SMTP.CreateMessage(SenderName,SenderAddress,Recipient,Subject,Body,true);

        Body := '';

        while InStreamTemplate.eos() = false do begin
          InStreamTemplate.ReadText(InSReadChar,1);
          if InSReadChar = '%' then begin
            SMTP.AppendBody(Body);
            Body := InSReadChar;
            if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
            if (InSReadChar >= '0') and (InSReadChar <= '9') then begin
              Body := Body + '1';
              CharNo := InSReadChar;
              while (InSReadChar >= '0') and (InSReadChar <= '9') do begin
                if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
                if (InSReadChar >= '0') and (InSReadChar <= '9') then
                  CharNo := CharNo + InSReadChar;
              end;
            end else
              Body := Body + InSReadChar;
            case CharNo of
                '1': Body := '';
                '2': Body := '';
            end;
            SMTP.AppendBody(Body);
            Body := InSReadChar;
          end else begin
            Body := Body + InSReadChar;
            I := I + 1;
            if I = 500 then begin
              SMTP.AppendBody(Body);
              Body := '';
              I := 0;
            end;
          end;
        end;
        SMTP.AppendBody(Body);

        // Find Approval entries overdue and append to template
        if QytAppEntDue > 0 then begin
          Body := StrSubstNo('<p class="MsoNormal"><font face="Arial size 2"><b>%1</b></font></p>',Text022);
          SMTP.AppendBody(Body);
          if AppEntriesDue.Find('-') then begin
            repeat
              BuildOverdueLine(AppEntriesDue);
              InsertOverdueLogEntries(AppEntriesDue);
            until AppEntriesDue.Next = 0;
          end;
        end;

        // Find Approval entries not overdue and append to template
        if QtyAppEntries > 0 then begin
          Body := StrSubstNo('<p class="MsoNormal"><font face="Arial size 2"><b>%1</b></font></p>',Text030);
          SMTP.AppendBody(Body);
          if AppEntriesNotDue.Find('-') then begin
            repeat
              BuildDueLine(AppEntriesNotDue);
            until AppEntriesNotDue.Next = 0;
          end;
        end;
        SMTP.Send;
    end;


    procedure GetEmailAddress(AppEntry: Record "Approval Entry")
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(AppEntry."Sender ID");
        UserSetup.TestField("E-Mail");
        SenderAddress := UserSetup."E-Mail";
        UserSetup.Get(AppEntry."Approver ID");
        UserSetup.TestField("E-Mail");
        Recipient := UserSetup."E-Mail";
        UserSetup.Get(UserId);
        UserSetup.TestField("E-Mail");
        FromUser := UserSetup."E-Mail";
    end;


    procedure CheckEntriesDue(DueDate: Date)
    var
        UserSetup: Record "User Setup";
        AppEnt: Record "Approval Entry" temporary;
        AppEntDue: Record "Approval Entry" temporary;
        AppEntries: Record "Approval Entry";
        ApprovalMgt: Codeunit "IC Setup Diagnostics";
        OverdueFound: Boolean;
    begin
        if UserSetup.Find('-') then begin
          UserSetup.TestField("E-Mail");
          repeat
            OverdueFound := false;
            AppEnt.DeleteAll;
            AppEntDue.DeleteAll;
            AppEntries.SetCurrentkey("Approver ID",Status);
            AppEntries.SetRange("Approver ID",UserSetup."User ID");
            AppEntries.SetRange(Status,AppEntries.Status::Open);
            if AppEntries.Find('-') then begin
              repeat
                if AppEntries."Due Date" <= DueDate then begin
                  AppEntDue := AppEntries;
                  AppEntDue.Insert;
                  OverdueFound := true;
                end else begin
                  AppEnt := AppEntries;
                  AppEnt.Insert;
                end;
              until AppEntries.Next = 0;
              if OverdueFound then
                ApprovalMgt.SendOverdueApprovalsMail(UserSetup."E-Mail",AppEnt,AppEntDue);
            end;
          until UserSetup.Next = 0;
        end;
    end;


    procedure FillSalesTemplate(var Body: Text[254];TextNo: Text[30];Header: Record "Sales Header";AppEntry: Record "Approval Entry";CalledFrom: Option Approve,Cancel,Reject,Delegate)
    begin
        case TextNo of
          '1': Body := StrSubstNo(Text001,Header."Document Type");
          '2': Body := StrSubstNo(Body,Header."No.");
          '3': case CalledFrom of
              Calledfrom::Approve: Body := StrSubstNo(Body,Text003);
              Calledfrom::Cancel: Body := StrSubstNo(Body,Text014);
              Calledfrom::Reject: Body := StrSubstNo(Body,Text016);
              Calledfrom::Delegate: Body := StrSubstNo(Body,Text020);
            end;
          '4': case CalledFrom of
              Calledfrom::Approve: Body := '';
              Calledfrom::Cancel: Body := '';
              Calledfrom::Reject: Body := '';
              Calledfrom::Delegate: Body := '';
            end;
          '5': Body := '';
          '6': Body := '';
          '7': Body := StrSubstNo(Body,AppEntry.FieldCaption(Amount));
          '8': Body := StrSubstNo(Body,AppEntry."Currency Code");
          '9': Body := StrSubstNo(Body,AppEntry.Amount);
          '10': Body := StrSubstNo(Body,AppEntry.FieldCaption("Amount (LCY)"));
          '11': Body := StrSubstNo(Body,AppEntry."Amount (LCY)");
          '12': Body := StrSubstNo(Body,Text005);
          '13': Body := StrSubstNo(Body,Header."Bill-to Customer No.");
          '14': Body := StrSubstNo(Body,Header."Bill-to Name");
          '15': Body := StrSubstNo(Body,AppEntry.FieldCaption("Due Date"));
          '16': Body := StrSubstNo(Body,AppEntry."Due Date");
          '17': Body := Text042;
          '18': Body := StrSubstNo(Body,AppEntry."Available Credit Limit (LCY)");
        end;
    end;


    procedure FillPurchaseTemplate(var Body: Text[254];TextNo: Text[30];Header: Record "Purchase Header";AppEntry: Record "Approval Entry";CalledFrom: Option Approve,Cancel,Reject,Delegate)
    begin
        case TextNo of
          '1': Body := StrSubstNo(Text002,Header."Document Type");
          '2': Body := StrSubstNo(Body,Header."No.");
          '3': case CalledFrom of
              Calledfrom::Approve: Body := StrSubstNo(Body,Text003);
              Calledfrom::Cancel: Body := StrSubstNo(Body,Text014);
              Calledfrom::Reject: Body := StrSubstNo(Body,Text016);
              Calledfrom::Delegate: Body := StrSubstNo(Body,Text020);
            end;
          '4': case CalledFrom of
              Calledfrom::Approve: Body := '';
              Calledfrom::Cancel: Body := '';
              Calledfrom::Reject: Body := '';
              Calledfrom::Delegate: Body := '';
            end;
          '5': Body := '';
          '6': Body := '';
          '7': Body := StrSubstNo(Body,AppEntry.FieldCaption(Amount));
          '8': Body := StrSubstNo(Body,AppEntry."Currency Code");
          '9': Body := StrSubstNo(Body,AppEntry.Amount);
          '10': Body := StrSubstNo(Body,AppEntry.FieldCaption("Amount (LCY)"));
          '11': Body := StrSubstNo(Body,AppEntry."Amount (LCY)");
          '12': Body := StrSubstNo(Body,Text018);
          '13': Body := StrSubstNo(Body,Header."Pay-to Vendor No.");
          '14': Body := StrSubstNo(Body,Header."Pay-to Name");
          '15': Body := StrSubstNo(Body,AppEntry.FieldCaption("Due Date"));
          '16': Body := StrSubstNo(Body,AppEntry."Due Date");
          '17': begin
              if AppEntry."Limit Type" = AppEntry."limit type"::"Request Limits" then
                Body := Text043
              else
                Body := ' ';
            end;
          '18': begin
              if AppEntry."Limit Type" = AppEntry."limit type"::"Request Limits" then
                Body := StrSubstNo(Body,AppEntry."Amount (LCY)")
              else
                Body := ' ';
            end;
        end;
    end;


    procedure SetTemplate(AppEntry: Record "Approval Entry")
    begin
        AppSetup.Get;
        AppSetup.CalcFields("Approval Template");
        if not AppSetup."Approval Template".Hasvalue then
          Error(Text040);
        AppSetup."Approval Template".CreateInstream(InStreamTemplate);
        SenderName := COMPANYNAME;
        Clear(SenderAddress);
        Clear(Recipient);
        GetEmailAddress(AppEntry);
    end;


    procedure SetOverdueTemplate()
    begin
        AppSetup.Get;
        AppSetup.CalcFields("Overdue Template");
        if not AppSetup."Overdue Template".Hasvalue then
          Error(Text041);
        AppSetup."Overdue Template".CreateInstream(InStreamTemplate);
        SenderName := COMPANYNAME;
    end;


    procedure BuildOverdueLine(AppEntry: Record "Approval Entry")
    var
        DueLine: Text[500];
        TextType: Text[30];
    begin
        case AppEntry."Table ID" of
          36: TextType := 'Sales';
          38: TextType := 'Purchase';
        end;
        DueLine := '<p class="MsoNormal"><span style="font-family:Arial size 2">' +
          Format(TextType,10) + Format(AppEntry."Document Type",15) +
          Format(AppEntry."Document No.",20) + Format(AppEntry."Due Date",10) + '</span></p>';
        SMTP.AppendBody(DueLine);
    end;


    procedure BuildDueLine(AppEntry: Record "Approval Entry")
    var
        TextType: Text[500];
        DueLine: Text[254];
    begin
        case AppEntry."Table ID" of
          36: TextType := 'Sales';
          38: TextType := 'Purchase';
        end;
        DueLine := '<p class="MsoNormal"><span style="font-family:Arial size 2">' +
          Format(TextType,10) + Format(AppEntry."Document Type",15) +
          Format(AppEntry."Document No.",20) + Format(AppEntry."Due Date",10) + '</span></p>';
        SMTP.AppendBody(DueLine);
    end;


    procedure BuildCommentLine(Comments: Record "Approval Comment Line")
    var
        CommentLine: Text[500];
    begin
        CommentLine := '<p class="MsoNormal"><span style="font-family:Arial size 2">' +
          Comments.Comment + '</span></p>';
        SMTP.AppendBody(CommentLine);
    end;


    procedure InsertOverdueLogEntries(AppEntry: Record "Approval Entry")
    var
        LogEntries: Record "Overdue Approval Entry";
        User: Record User;
    begin
        /*LogEntries."Approver ID" := AppEntry."Approver ID";
        IF WindowsLogin.GET(AppEntry."Approver ID") THEN BEGIN
          WindowsLogin.CALCFIELDS(ID,Name);
          LogEntries."Sent to Name" := WindowsLogin.Name;
        END ELSE IF DatabaseLogin.GET(AppEntry."Approver ID") THEN
          LogEntries."Sent to Name" := DatabaseLogin.Name;
        
        LogEntries."Table ID" := AppEntry."Table ID";
        LogEntries."Document Type" := AppEntry."Document Type";
        LogEntries."Document No." := AppEntry."Document No.";
        LogEntries."Sent to ID" := AppEntry."Approver ID";
        LogEntries."Sent Date" := TODAY;
        LogEntries."Sent Time" := TIME;
        LogEntries."E-Mail" := Recipient;
        LogEntries."Sequence No." := AppEntry."Sequence No.";
        LogEntries."Due Date" := AppEntry."Due Date";
        LogEntries."Approval Code" := AppEntry."Approval Code";
        LogEntries.INSERT; */

    end;


    procedure LaunchCheck(RunDate: Date)
    var
        ApprovalMannagement: Codeunit "IC Setup Diagnostics";
    begin
        ApprovalMannagement.CheckEntriesDue(RunDate);
    end;


    procedure SendMail()
    begin
        SMTP.Send;
        MailCreated := false;
    end;


    procedure SendApprovalsMail(var Doc_No: Code[20];var Doc_Type: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim";var ApprovalEntry: Record "Approval Entry")
    begin
        SetTemplate(ApprovalEntry);
        Subject := (Format(ApprovalEntry."Document Type"))+' APPROVAL REQUEST';
        Body := 'Approval Request for '+(Format(ApprovalEntry."Document Type"))+', Document No.: '+ApprovalEntry."Document No."+' Has been send to you for approval';

        SMTP.CreateMessage(SenderName,SenderAddress,Recipient,Subject,Body,true);
        Body := '';
        if Doc_Type=Doc_type::"Leave Application" then begin
          if ApprovalEntry."Sequence No."=1 then begin
            HRMLeaveRequisition.Reset;
            HRMLeaveRequisition.SetRange("No.",ApprovalEntry."Document No.");
            if HRMLeaveRequisition.Find('-') then begin
            Body:='The leave is to commence on: '+Format(HRMLeaveRequisition."Starting Date")+' and end on: '+Format(HRMLeaveRequisition."Return Date");
              end;
            end;
          end;

        while InStreamTemplate.eos() = false do begin
          InStreamTemplate.ReadText(InSReadChar,1);
          if InSReadChar = '%' then begin
            SMTP.AppendBody(Body);
            Body := InSReadChar;
            if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
            if (InSReadChar >= '0') and (InSReadChar <= '9') then begin
              Body := Body + '1';
              CharNo := InSReadChar;
              while (InSReadChar >= '0') and (InSReadChar <= '9') do begin
                if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
                if (InSReadChar >= '0') and (InSReadChar <= '9') then
                  CharNo := CharNo + InSReadChar;
              end;
            end else
              Body := Body + InSReadChar;
              Clear(calledFrom_Var);
              calledFrom_Var:=0;
            FillTemplate(Body,CharNo,Doc_No,Doc_Type,ApprovalEntry,calledFrom_Var);
            SMTP.AppendBody(Body);
            Body := InSReadChar;
          end else begin
            Body := Body + InSReadChar;
            I := I + 1;
            if I = 500 then begin
              SMTP.AppendBody(Body);
              Body := '';
              I := 0;
            end;
          end;
        end;
        SMTP.AppendBody(Body);
        SMTP.Send;
    end;


    procedure SendCancellationsMail(var Doc_No: Code[20];var Doc_Type: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim";var ApprovalEntry: Record "Approval Entry")
    begin
        if MailCreated then begin
          GetEmailAddress(ApprovalEntry);
          if Recipient <> SenderAddress then
            SMTP.AddCC(Recipient);
        end else begin
          SetTemplate(ApprovalEntry);
          Subject := StrSubstNo(Text007,Text009);
          Body := Text013;

          SMTP.CreateMessage(SenderName,FromUser,SenderAddress,Subject,Body,true);
          if Recipient <> SenderAddress then
            SMTP.AddCC(Recipient);

          Body := '';

          while InStreamTemplate.eos() = false do begin
            InStreamTemplate.ReadText(InSReadChar,1);
            if InSReadChar = '%' then begin
              SMTP.AppendBody(Body);
              Body := InSReadChar;
              if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
              if (InSReadChar >= '0') and (InSReadChar <= '9') then begin
                Body := Body + '1';
                CharNo := InSReadChar;
                while (InSReadChar >= '0') and (InSReadChar <= '9') do begin
                  if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
                  if (InSReadChar >= '0') and (InSReadChar <= '9') then
                    CharNo := CharNo + InSReadChar;
                end;
              end else
                Body := Body + InSReadChar;
              Clear(calledFrom_Var);
              calledFrom_Var:=1;
            FillTemplate(Body,CharNo,Doc_No,Doc_Type,ApprovalEntry,calledFrom_Var);
              SMTP.AppendBody(Body);
              Body := InSReadChar;
            end else begin
              Body := Body + InSReadChar;
              I := I + 1;
              if I = 500 then begin
                SMTP.AppendBody(Body);
                Body := '';
                I := 0;
              end;
            end;
          end;
          SMTP.AppendBody(Body);
          MailCreated := true;
        end;
    end;


    procedure SendRejectionsMail(var Doc_No: Code[20];var Doc_Type: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim";var ApprovalEntry: Record "Approval Entry")
    var
        AppCommentLine: Record "Approval Comment Line";
    begin
        if MailCreated then begin
          GetEmailAddress(ApprovalEntry);
          if Recipient <> SenderAddress then
            SMTP.AddCC(Recipient);
        end else begin
          SetTemplate(ApprovalEntry);
          Subject := StrSubstNo(Text007,Text010);
          Body := Text013;

          SMTP.CreateMessage(SenderName,FromUser,SenderAddress,Subject,Body,true);
          SMTP.AddCC(Recipient);
          Body := '';

          while InStreamTemplate.eos() = false do begin
            InStreamTemplate.ReadText(InSReadChar,1);
            if InSReadChar = '%' then begin
              SMTP.AppendBody(Body);
              Body := InSReadChar;
              if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
              if (InSReadChar >= '0') and (InSReadChar <= '9') then begin
                Body := Body + '1';
                CharNo := InSReadChar;
                while (InSReadChar >= '0') and (InSReadChar <= '9') do begin
                  if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
                  if (InSReadChar >= '0') and (InSReadChar <= '9') then
                    CharNo := CharNo + InSReadChar;
                end;
              end else
                Body := Body + InSReadChar;
              Clear(calledFrom_Var);
              calledFrom_Var:=2;
            FillTemplate(Body,CharNo,Doc_No,Doc_Type,ApprovalEntry,calledFrom_Var);
              SMTP.AppendBody(Body);
              Body := InSReadChar;
            end else begin
              Body := Body + InSReadChar;
              I := I + 1;
              if I = 500 then begin
                SMTP.AppendBody(Body);
                Body := '';
                I := 0;
              end;
            end;
          end;
          SMTP.AppendBody(Body);

          // Append Comment Lines
          ApprovalEntry.CalcFields(Comment);
          if ApprovalEntry.Comment then begin
            AppCommentLine.SetCurrentkey("Table ID","Document Type","Document No.");
            AppCommentLine.SetRange("Table ID",ApprovalEntry."Table ID");
            AppCommentLine.SetRange("Document Type",ApprovalEntry."Document Type");
            AppCommentLine.SetRange("Document No.",ApprovalEntry."Document No.");
            if AppCommentLine.Find('-') then begin
              Body := StrSubstNo('<p class="MsoNormal"><font face="Arial size 2"><b>%1</b></font></p>',Text033);
              SMTP.AppendBody(Body);
              repeat
                BuildCommentLine(AppCommentLine);
              until AppCommentLine.Next = 0;
            end;
          end;
          MailCreated := true;
        end;
    end;


    procedure SendDelegationsMail(var Doc_No: Code[20];var Doc_Type: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Farmer Application",Vehicle_Reg,"Medical Claim";var ApprovalEntry: Record "Approval Entry")
    begin
        SetTemplate(ApprovalEntry);
        Subject := StrSubstNo(Text007,Text011);
        Body := Text013;

        SMTP.CreateMessage(SenderName,FromUser,Recipient,Subject,Body,true);
        SMTP.AddCC(SenderAddress);
        Body := '';

        while InStreamTemplate.eos() = false do begin
          InStreamTemplate.ReadText(InSReadChar,1);
          if InSReadChar = '%' then begin
            SMTP.AppendBody(Body);
            Body := InSReadChar;
            if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
            if (InSReadChar >= '0') and (InSReadChar <= '9') then begin
              Body := Body + '1';
              CharNo := InSReadChar;
              while (InSReadChar >= '0') and (InSReadChar <= '9') do begin
                if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
                if (InSReadChar >= '0') and (InSReadChar <= '9') then
                  CharNo := CharNo + InSReadChar;
              end;
            end else
              Body := Body + InSReadChar;
              Clear(calledFrom_Var);
              calledFrom_Var:=3;
            FillTemplate(Body,CharNo,Doc_No,Doc_Type,ApprovalEntry,calledFrom_Var);
            SMTP.AppendBody(Body);
            Body := InSReadChar;
          end else begin
            Body := Body + InSReadChar;
            I := I + 1;
            if I = 500 then begin
              SMTP.AppendBody(Body);
              Body := '';
              I := 0;
            end;
          end;
        end;
        SMTP.AppendBody(Body);
        SMTP.Send;
    end;


    procedure FillTemplate(var Body: Text[254];var TextNo: Text[30];var Doc_No: Code[20];var Doc_Type: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application";var AppEntry: Record "Approval Entry";var CalledFrom: Integer)
    begin
        case TextNo of
          '1': Body := StrSubstNo(Text001,Format(Doc_Type));
          '2': Body := StrSubstNo(Body,Doc_No);
          '3': case CalledFrom of
              0: Body := StrSubstNo(Body,Text003);
              1: Body := StrSubstNo(Body,Text014);
              2: Body := StrSubstNo(Body,Text016);
              3: Body := StrSubstNo(Body,Text020);
            end;
          '4': case CalledFrom of
              0: Body := ' Approval';
              1: Body := ' Cancelation';
              2: Body := ' Rejection';
              3: Body := ' Delegation';
            end;
          '5': Body := '';
          '6': Body := '';
          '7': Body :='';// STRSUBSTNO(Body,AppEntry.FIELDCAPTION(Amount));
          '8': Body :='';// STRSUBSTNO(Body,AppEntry."Currency Code");
          '9': Body := '';//STRSUBSTNO(Body,AppEntry.Amount);
          '10': Body := '';//STRSUBSTNO(Body,AppEntry.FIELDCAPTION("Amount (LCY)"));
          '11': Body := '';//STRSUBSTNO(Body,AppEntry."Amount (LCY)");
          '12': Body := StrSubstNo(Body,Text005);
          '13': Body := '';//STRSUBSTNO(Body,Header."Bill-to Customer No.");
          '14': Body := '';//STRSUBSTNO(Body,Header."Bill-to Name");
          '15': Body := StrSubstNo(Body,AppEntry.FieldCaption("Due Date"));
          '16': Body := StrSubstNo(Body,AppEntry."Due Date");
          '17': Body := Text042;
          '18': Body := '';//STRSUBSTNO(Body,AppEntry."Available Credit Limit (LCY)");
        end;
    end;


    procedure SendLeaveApprovalsMail(leaveApplic: Record UnknownRecord61125;ApprovalEntry: Record "Approval Entry")
    var
        emps: Record UnknownRecord61188;
        UserSetupz: Record "User Setup";
    begin

        SetTemplate(ApprovalEntry);
        Subject := 'LEAVE APPLICATION - RELEAVER';
        Body := 'ERP APPROVAL NOTIFICATION';
        emps.Reset;
        emps.SetRange("No.",leaveApplic."Employee No");
        if emps.Find('-') then begin
          end;
          UserSetupz.Reset;
          UserSetupz.SetRange("Staff No",leaveApplic."Reliever No.");
          if UserSetupz.FindFirst then begin
            end;
            UserSetupz.TestField("E-Mail");

        SMTP.CreateMessage(SenderName,SenderAddress,UserSetupz."E-Mail",Subject,Body,true);
        Body := 'This is to Notify you that '+emps."First Name"+' '+emps."Middle Name"+' '+emps."Last Name"+' has selected you as his/her releaver while on leave between '+
        Format(leaveApplic."Starting Date")+' AND '+Format(leaveApplic."Return Date");
        SMTP.AppendBody(Body);
        SMTP.Send;
    end;


    procedure FillLeaveTemplate(Body: Text;TextNo: Text;Header: Record UnknownRecord61125;AppEntry: Record "Approval Entry";CalledFrom: Option Approve,Cancel,Reject,Delegate)
    begin

        case TextNo of
          '1': Body := StrSubstNo(Text001,'Leave Application');
          '2': Body := StrSubstNo(Body,Header."No.");
          '3': case CalledFrom of
              Calledfrom::Approve: Body := StrSubstNo(Body,Text003);
              Calledfrom::Cancel: Body := StrSubstNo(Body,Text014);
              Calledfrom::Reject: Body := StrSubstNo(Body,Text016);
              Calledfrom::Delegate: Body := StrSubstNo(Body,Text020);
            end;
          '4': case CalledFrom of
              Calledfrom::Approve: Body := '';
              Calledfrom::Cancel: Body := '';
              Calledfrom::Reject: Body := '';
              Calledfrom::Delegate: Body := '';
            end;
          '5': Body := '';
          '6': Body := '';
          '7': Body :='';// STRSUBSTNO(Body,AppEntry.FIELDCAPTION(Amount));
          '8': Body :='';// STRSUBSTNO(Body,AppEntry."Currency Code");
          '9': Body := '';//STRSUBSTNO(Body,AppEntry.Amount);
          '10': Body := '';//STRSUBSTNO(Body,AppEntry.FIELDCAPTION("Amount (LCY)"));
          '11': Body := '';//STRSUBSTNO(Body,AppEntry."Amount (LCY)");
          '12': Body := StrSubstNo(Body,Text005);
          '13': Body := '';//STRSUBSTNO(Body,Header."Bill-to Customer No.");
          '14': Body := '';//STRSUBSTNO(Body,Header."Bill-to Name");
          '15': Body := StrSubstNo(Body,AppEntry.FieldCaption("Due Date"));
          '16': Body := StrSubstNo(Body,AppEntry."Due Date");
          '17': Body := Text042;
          '18': Body := '';//STRSUBSTNO(Body,AppEntry."Available Credit Limit (LCY)");
        end;
    end;


    procedure SendVenueApprovalsMail(VenueApplic: Record UnknownRecord77709;ApprovalEntry: Record "Approval Entry")
    begin

        SetTemplate(ApprovalEntry);
        Subject := StrSubstNo(Text007,Text008);
        Body := Text013;

        SMTP.CreateMessage(SenderName,SenderAddress,Recipient,Subject,Body,true);
        Body := '';

        while InStreamTemplate.eos() = false do begin
          InStreamTemplate.ReadText(InSReadChar,1);
          if InSReadChar = '%' then begin
            SMTP.AppendBody(Body);
            Body := InSReadChar;
            if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
            if (InSReadChar >= '0') and (InSReadChar <= '9') then begin
              Body := Body + '1';
              CharNo := InSReadChar;
              while (InSReadChar >= '0') and (InSReadChar <= '9') do begin
                if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
                if (InSReadChar >= '0') and (InSReadChar <= '9') then
                  CharNo := CharNo + InSReadChar;
              end;
            end else
              Body := Body + InSReadChar;
            FillVenueTemplate(Body,CharNo,VenueApplic,ApprovalEntry,0);
            SMTP.AppendBody(Body);
            Body := InSReadChar;
          end else begin
            Body := Body + InSReadChar;
            I := I + 1;
            if I = 500 then begin
              SMTP.AppendBody(Body);
              Body := '';
              I := 0;
            end;
          end;
        end;
        SMTP.AppendBody(Body);
        SMTP.Send;
    end;


    procedure FillVenueTemplate(Body: Text;TextNo: Text;Header: Record UnknownRecord77709;AppEntry: Record "Approval Entry";CalledFrom: Option Approve,Cancel,Reject,Delegate)
    begin

        case TextNo of
          '1': Body := StrSubstNo(Text001,'Leave Application');
          '2': Body := StrSubstNo(Body,Header."Booking Id");
          '3': case CalledFrom of
              Calledfrom::Approve: Body := StrSubstNo(Body,Text003);
              Calledfrom::Cancel: Body := StrSubstNo(Body,Text014);
              Calledfrom::Reject: Body := StrSubstNo(Body,Text016);
              Calledfrom::Delegate: Body := StrSubstNo(Body,Text020);
            end;
          '4': case CalledFrom of
              Calledfrom::Approve: Body := '';
              Calledfrom::Cancel: Body := '';
              Calledfrom::Reject: Body := '';
              Calledfrom::Delegate: Body := '';
            end;
          '5': Body := '';
          '6': Body := '';
          '7': Body :='';// STRSUBSTNO(Body,AppEntry.FIELDCAPTION(Amount));
          '8': Body :='';// STRSUBSTNO(Body,AppEntry."Currency Code");
          '9': Body := '';//STRSUBSTNO(Body,AppEntry.Amount);
          '10': Body := '';//STRSUBSTNO(Body,AppEntry.FIELDCAPTION("Amount (LCY)"));
          '11': Body := '';//STRSUBSTNO(Body,AppEntry."Amount (LCY)");
          '12': Body := StrSubstNo(Body,Text005);
          '13': Body := '';//STRSUBSTNO(Body,Header."Bill-to Customer No.");
          '14': Body := '';//STRSUBSTNO(Body,Header."Bill-to Name");
          '15': Body := StrSubstNo(Body,AppEntry.FieldCaption("Due Date"));
          '16': Body := StrSubstNo(Body,AppEntry."Due Date");
          '17': Body := Text042;
          '18': Body := '';//STRSUBSTNO(Body,AppEntry."Available Credit Limit (LCY)");
        end;
    end;


    procedure SendApprovedEmails(var Doc_No: Code[20];var Doc_Type: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Venue Booking";var ApprovalEntry: Record "Approval Entry")
    var
        UserSetup: Record "User Setup";
    begin
        SetTemplate(ApprovalEntry);
        Subject := StrSubstNo(Text007,Text008);
        Body := Text013;
        //ZDasfa
        if UserSetup.Get(ApprovalEntry."Sender ID") then
          UserSetup.TestField("E-Mail");
        SMTP.CreateMessage(SenderName,SenderAddress,UserSetup."E-Mail",Subject,Body,true);
        Body := 'Your Approval request for Doc. Type: '+(Format(ApprovalEntry."Document Type"))+', Document No: '+(Format(ApprovalEntry."Document No."))+' has been Approved';
        /*
        WHILE InStreamTemplate.EOS() = FALSE DO BEGIN
          InStreamTemplate.READTEXT(InSReadChar,1);
          IF InSReadChar = '%' THEN BEGIN
            SMTP.AppendBody(Body);
            Body := InSReadChar;
            IF InStreamTemplate.READTEXT(InSReadChar,1) <> 0 THEN;
            IF (InSReadChar >= '0') AND (InSReadChar <= '9') THEN BEGIN
              Body := Body + '1';
              CharNo := InSReadChar;
              WHILE (InSReadChar >= '0') AND (InSReadChar <= '9') DO BEGIN
                IF InStreamTemplate.READTEXT(InSReadChar,1) <> 0 THEN;
                IF (InSReadChar >= '0') AND (InSReadChar <= '9') THEN
                  CharNo := CharNo + InSReadChar;
              END;
            END ELSE
              Body := Body + InSReadChar;
              CLEAR(calledFrom_Var);
              calledFrom_Var:=0;
            FillTemplate(Body,CharNo,Doc_No,Doc_Type,ApprovalEntry,calledFrom_Var);
            SMTP.AppendBody(Body);
            Body := InSReadChar;
          END ELSE BEGIN
            Body := Body + InSReadChar;
            I := I + 1;
            IF I = 500 THEN BEGIN
              SMTP.AppendBody(Body);
              Body := '';
              I := 0;
            END;
          END;
        END;*/
        SMTP.AppendBody(Body);
        SMTP.Send;

    end;


    procedure SendtransportMail(leaveApplic: Record UnknownRecord61801;ApprovalEntry: Record "Approval Entry")
    begin

        SetTemplate(ApprovalEntry);
        Subject := StrSubstNo(Text007,Text008);
        Body := Text013;

        SMTP.CreateMessage(SenderName,SenderAddress,Recipient,Subject,Body,true);
        Body := '';

        while InStreamTemplate.eos() = false do begin
          InStreamTemplate.ReadText(InSReadChar,1);
          if InSReadChar = '%' then begin
            SMTP.AppendBody(Body);
            Body := InSReadChar;
            if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
            if (InSReadChar >= '0') and (InSReadChar <= '9') then begin
              Body := Body + '1';
              CharNo := InSReadChar;
              while (InSReadChar >= '0') and (InSReadChar <= '9') do begin
                if InStreamTemplate.ReadText(InSReadChar,1) <> 0 then;
                if (InSReadChar >= '0') and (InSReadChar <= '9') then
                  CharNo := CharNo + InSReadChar;
              end;
            end else
              Body := Body + InSReadChar;
            FillTransportTemplate(Body,CharNo,leaveApplic,ApprovalEntry,0);
            SMTP.AppendBody(Body);
            Body := InSReadChar;
          end else begin
            Body := Body + InSReadChar;
            I := I + 1;
            if I = 500 then begin
              SMTP.AppendBody(Body);
              Body := '';
              I := 0;
            end;
          end;
        end;
        SMTP.AppendBody(Body);
        SMTP.Send;
    end;


    procedure FillTransportTemplate(Body: Text;TextNo: Text;Header: Record UnknownRecord61801;AppEntry: Record "Approval Entry";CalledFrom: Option Approve,Cancel,Reject,Delegate)
    begin

        case TextNo of
          '1': Body := StrSubstNo(Text001,'Transport Requisition');
          '2': Body := StrSubstNo(Body,Header."Transport Requisition No");
          '3': case CalledFrom of
              Calledfrom::Approve: Body := StrSubstNo(Body,Text003);
              Calledfrom::Cancel: Body := StrSubstNo(Body,Text014);
              Calledfrom::Reject: Body := StrSubstNo(Body,Text016);
              Calledfrom::Delegate: Body := StrSubstNo(Body,Text020);
            end;
          '4': case CalledFrom of
              Calledfrom::Approve: Body := '';
              Calledfrom::Cancel: Body := '';
              Calledfrom::Reject: Body := '';
              Calledfrom::Delegate: Body := '';
            end;
          '5': Body := '';
          '6': Body := '';
          '7': Body :='';// STRSUBSTNO(Body,AppEntry.FIELDCAPTION(Amount));
          '8': Body :='';// STRSUBSTNO(Body,AppEntry."Currency Code");
          '9': Body := '';//STRSUBSTNO(Body,AppEntry.Amount);
          '10': Body := '';//STRSUBSTNO(Body,AppEntry.FIELDCAPTION("Amount (LCY)"));
          '11': Body := '';//STRSUBSTNO(Body,AppEntry."Amount (LCY)");
          '12': Body := StrSubstNo(Body,Text005);
          '13': Body := '';//STRSUBSTNO(Body,Header."Bill-to Customer No.");
          '14': Body := '';//STRSUBSTNO(Body,Header."Bill-to Name");
          '15': Body := StrSubstNo(Body,AppEntry.FieldCaption("Due Date"));
          '16': Body := StrSubstNo(Body,AppEntry."Due Date");
          '17': Body := Text042;
          '18': Body := '';//STRSUBSTNO(Body,AppEntry."Available Credit Limit (LCY)");
        end;
    end;


    procedure SendVenueApprovalMail(Doc_No: Code[20];Doc_Type: Code[30];UserMail: Text[100];UserName: Text[150]) ok: Boolean
    var
        SMTPMailSetup: Record "SMTP Mail Setup";
    begin
        Clear(ok);
        Subject := Doc_Type+' APPROVAL REQUEST';
        Body := 'Approval Request for '+Doc_Type+', Document No.: '+Doc_No+' Has been send to you for approval';
        if SMTPMailSetup.Find('-') then;

        SMTP.CreateMessage(UserName,UserMail,SMTPMailSetup."Venue Booking Mail",Subject,Body,true);
        Body := '';
        // // IF Doc_Type=Doc_Type::"Leave Application" THEN BEGIN
        // //  IF ApprovalEntry."Sequence No."=1 THEN BEGIN
        // //    HRMLeaveRequisition.RESET;
        // //    HRMLeaveRequisition.SETRANGE("No.",ApprovalEntry."Document No.");
        // //    IF HRMLeaveRequisition.FIND('-') THEN BEGIN
        // //    Body:='The leave is to commence on: '+FORMAT(HRMLeaveRequisition."Starting Date")+' and end on: '+FORMAT(HRMLeaveRequisition."Return Date");
        // //      END;
        // //    END;
        // //  END;

        // WHILE InStreamTemplate.EOS() = FALSE DO BEGIN
        //  InStreamTemplate.READTEXT(InSReadChar,1);
        //  IF InSReadChar = '%' THEN BEGIN
        //    SMTP.AppendBody(Body);
        //    Body := InSReadChar;
        //    IF InStreamTemplate.READTEXT(InSReadChar,1) <> 0 THEN;
        //    IF (InSReadChar >= '0') AND (InSReadChar <= '9') THEN BEGIN
        //      Body := Body + '1';
        //      CharNo := InSReadChar;
        //      WHILE (InSReadChar >= '0') AND (InSReadChar <= '9') DO BEGIN
        //        IF InStreamTemplate.READTEXT(InSReadChar,1) <> 0 THEN;
        //        IF (InSReadChar >= '0') AND (InSReadChar <= '9') THEN
        //          CharNo := CharNo + InSReadChar;
        //      END;
        //    END ELSE
        //      Body := Body + InSReadChar;
        //      CLEAR(calledFrom_Var);
        //      calledFrom_Var:=0;
        //    FillGeneralTemplate(Body,CharNo,Doc_No,Doc_Type,calledFrom_Var);
        //    SMTP.AppendBody(Body);
        //    Body := InSReadChar;
        //  END ELSE BEGIN
        //    Body := Body + InSReadChar;
        //    I := I + 1;
        //    IF I = 500 THEN BEGIN
        //      SMTP.AppendBody(Body);
        //      Body := '';
        //      I := 0;
        //    END;
        //  END;
        // END;
        SMTP.AppendBody(Body);
        SMTP.Send;
        ok:=true;
    end;


    procedure SendVenueApprovedlMail(Doc_No: Code[20];Doc_Type: Code[30];UserMail: Text[100];UserName: Text[150])
    var
        SMTPMailSetup: Record "SMTP Mail Setup";
    begin
        Subject := Doc_Type+' VENUE BOOKING APPROVAL';
        Body := ' \Approval Request for '+Doc_Type+', Document No.: '+Doc_No+' Has been APPROVED';
        if SMTPMailSetup.Find('-') then;
        
        SMTP.CreateMessage(UserName,SMTPMailSetup."Venue Booking Mail",UserMail,Subject,Body,true);
        Body := '';
        /*// // IF Doc_Type=Doc_Type::"Leave Application" THEN BEGIN
        // //  IF ApprovalEntry."Sequence No."=1 THEN BEGIN
        // //    HRMLeaveRequisition.RESET;
        // //    HRMLeaveRequisition.SETRANGE("No.",ApprovalEntry."Document No.");
        // //    IF HRMLeaveRequisition.FIND('-') THEN BEGIN
        // //    Body:='The leave is to commence on: '+FORMAT(HRMLeaveRequisition."Starting Date")+' and end on: '+FORMAT(HRMLeaveRequisition."Return Date");
        // //      END;
        // //    END;
        // //  END;
        
        WHILE InStreamTemplate.EOS() = FALSE DO BEGIN
          InStreamTemplate.READTEXT(InSReadChar,1);
          IF InSReadChar = '%' THEN BEGIN
            SMTP.AppendBody(Body);
            Body := InSReadChar;
            IF InStreamTemplate.READTEXT(InSReadChar,1) <> 0 THEN;
            IF (InSReadChar >= '0') AND (InSReadChar <= '9') THEN BEGIN
              Body := Body + '1';
              CharNo := InSReadChar;
              WHILE (InSReadChar >= '0') AND (InSReadChar <= '9') DO BEGIN
                IF InStreamTemplate.READTEXT(InSReadChar,1) <> 0 THEN;
                IF (InSReadChar >= '0') AND (InSReadChar <= '9') THEN
                  CharNo := CharNo + InSReadChar;
              END;
            END ELSE
              Body := Body + InSReadChar;
              CLEAR(calledFrom_Var);
              calledFrom_Var:=0;
            FillGeneralTemplate(Body,CharNo,Doc_No,Doc_Type,calledFrom_Var);
            SMTP.AppendBody(Body);
            Body := InSReadChar;
          END ELSE BEGIN
            Body := Body + InSReadChar;
            I := I + 1;
            IF I = 500 THEN BEGIN
              SMTP.AppendBody(Body);
              Body := '';
              I := 0;
            END;
          END;
        END;*/
        SMTP.AppendBody(Body);
        SMTP.Send;

    end;


    procedure FillGeneralTemplate(var Body: Text[254];var TextNo: Text[30];var Doc_No: Code[20];var Doc_Type: Code[20];var CalledFrom: Integer)
    begin
        case TextNo of
          '1': Body := StrSubstNo(Text001,Format(Doc_Type));
          '2': Body := StrSubstNo(Body,Doc_No);
          '3': case CalledFrom of
              0: Body := StrSubstNo(Body,Text003);
              1: Body := StrSubstNo(Body,Text014);
              2: Body := StrSubstNo(Body,Text016);
              3: Body := StrSubstNo(Body,Text020);
            end;
          '4': case CalledFrom of
              0: Body := ' Approval';
              1: Body := ' Cancelation';
              2: Body := ' Rejection';
              3: Body := ' Delegation';
            end;
          '5': Body := '';
          '6': Body := '';
          '7': Body :='';// STRSUBSTNO(Body,AppEntry.FIELDCAPTION(Amount));
          '8': Body :='';// STRSUBSTNO(Body,AppEntry."Currency Code");
          '9': Body := '';//STRSUBSTNO(Body,AppEntry.Amount);
          '10': Body := '';//STRSUBSTNO(Body,AppEntry.FIELDCAPTION("Amount (LCY)"));
          '11': Body := '';//STRSUBSTNO(Body,AppEntry."Amount (LCY)");
          '12': Body := StrSubstNo(Body,Text005);
          '13': Body := '';//STRSUBSTNO(Body,Header."Bill-to Customer No.");
          '14': Body := '';//STRSUBSTNO(Body,Header."Bill-to Name");
          //'15': Body := STRSUBSTNO(Body,AppEntry.FIELDCAPTION("Due Date"));
          //'16': Body := STRSUBSTNO(Body,AppEntry."Due Date");
          '17': Body := Text042;
          '18': Body := '';//STRSUBSTNO(Body,AppEntry."Available Credit Limit (LCY)");
        end;
    end;


    procedure SendFuelApprovalsMail(FuelReq: Record UnknownRecord55500;ApprovalEntry: Record "Approval Entry")
    var
        emps: Record UnknownRecord61188;
        UserSetupz: Record "User Setup";
    begin

        SetTemplate(ApprovalEntry);
        Subject := 'FUEL REQUISITION';
        Body := 'ERP APPROVAL NOTIFICATION';
        emps.Reset;
        emps.SetRange("No.",FuelReq."Emp. No.");
        if emps.Find('-') then begin
          end;
          UserSetupz.Reset;
          UserSetupz.SetRange("Staff No",FuelReq."Emp. No.");
          if UserSetupz.FindFirst then begin
            end;
            UserSetupz.TestField("E-Mail");

        SMTP.CreateMessage(SenderName,SenderAddress,UserSetupz."E-Mail",Subject,Body,true);
        Body := 'This is to Notify you that an Approval request for Fuel requisition has been send to you for approval.';
        SMTP.AppendBody(Body);
        SMTP.Send;
    end;


    procedure FillFuelTemplate(Body: Text;TextNo: Text;Header: Record UnknownRecord61125;AppEntry: Record "Approval Entry";CalledFrom: Option Approve,Cancel,Reject,Delegate)
    begin

        case TextNo of
          '1': Body := StrSubstNo(Text001,'Leave Application');
          '2': Body := StrSubstNo(Body,Header."No.");
          '3': case CalledFrom of
              Calledfrom::Approve: Body := StrSubstNo(Body,Text003);
              Calledfrom::Cancel: Body := StrSubstNo(Body,Text014);
              Calledfrom::Reject: Body := StrSubstNo(Body,Text016);
              Calledfrom::Delegate: Body := StrSubstNo(Body,Text020);
            end;
          '4': case CalledFrom of
              Calledfrom::Approve: Body := '';
              Calledfrom::Cancel: Body := '';
              Calledfrom::Reject: Body := '';
              Calledfrom::Delegate: Body := '';
            end;
          '5': Body := '';
          '6': Body := '';
          '7': Body :='';// STRSUBSTNO(Body,AppEntry.FIELDCAPTION(Amount));
          '8': Body :='';// STRSUBSTNO(Body,AppEntry."Currency Code");
          '9': Body := '';//STRSUBSTNO(Body,AppEntry.Amount);
          '10': Body := '';//STRSUBSTNO(Body,AppEntry.FIELDCAPTION("Amount (LCY)"));
          '11': Body := '';//STRSUBSTNO(Body,AppEntry."Amount (LCY)");
          '12': Body := StrSubstNo(Body,Text005);
          '13': Body := '';//STRSUBSTNO(Body,Header."Bill-to Customer No.");
          '14': Body := '';//STRSUBSTNO(Body,Header."Bill-to Name");
          '15': Body := StrSubstNo(Body,AppEntry.FieldCaption("Due Date"));
          '16': Body := StrSubstNo(Body,AppEntry."Due Date");
          '17': Body := Text042;
          '18': Body := '';//STRSUBSTNO(Body,AppEntry."Available Credit Limit (LCY)");
        end;
    end;


    procedure SendMaintenanceApprovalsMail(MaintReq: Record UnknownRecord55517;ApprovalEntry: Record "Approval Entry")
    var
        emps: Record UnknownRecord61188;
        UserSetupz: Record "User Setup";
    begin

        SetTemplate(ApprovalEntry);
        Subject := 'FUEL REQUISITION';
        Body := 'ERP APPROVAL NOTIFICATION';
        emps.Reset;
        emps.SetRange("No.",MaintReq."Emp. No.");
        if emps.Find('-') then begin
          end;
          UserSetupz.Reset;
          UserSetupz.SetRange("Staff No",MaintReq."Emp. No.");
          if UserSetupz.FindFirst then begin
            end;
            UserSetupz.TestField("E-Mail");

        SMTP.CreateMessage(SenderName,SenderAddress,UserSetupz."E-Mail",Subject,Body,true);
        Body := 'This is to Notify you that an Approval request for Fuel requisition has been send to you for approval.';
        SMTP.AppendBody(Body);
        SMTP.Send;
    end;


    procedure FillMaintenanceTemplate(Body: Text;TextNo: Text;Header: Record UnknownRecord61125;AppEntry: Record "Approval Entry";CalledFrom: Option Approve,Cancel,Reject,Delegate)
    begin

        case TextNo of
          '1': Body := StrSubstNo(Text001,'Maintenance Request');
          '2': Body := StrSubstNo(Body,Header."No.");
          '3': case CalledFrom of
              Calledfrom::Approve: Body := StrSubstNo(Body,Text003);
              Calledfrom::Cancel: Body := StrSubstNo(Body,Text014);
              Calledfrom::Reject: Body := StrSubstNo(Body,Text016);
              Calledfrom::Delegate: Body := StrSubstNo(Body,Text020);
            end;
          '4': case CalledFrom of
              Calledfrom::Approve: Body := '';
              Calledfrom::Cancel: Body := '';
              Calledfrom::Reject: Body := '';
              Calledfrom::Delegate: Body := '';
            end;
          '5': Body := '';
          '6': Body := '';
          '7': Body :='';// STRSUBSTNO(Body,AppEntry.FIELDCAPTION(Amount));
          '8': Body :='';// STRSUBSTNO(Body,AppEntry."Currency Code");
          '9': Body := '';//STRSUBSTNO(Body,AppEntry.Amount);
          '10': Body := '';//STRSUBSTNO(Body,AppEntry.FIELDCAPTION("Amount (LCY)"));
          '11': Body := '';//STRSUBSTNO(Body,AppEntry."Amount (LCY)");
          '12': Body := StrSubstNo(Body,Text005);
          '13': Body := '';//STRSUBSTNO(Body,Header."Bill-to Customer No.");
          '14': Body := '';//STRSUBSTNO(Body,Header."Bill-to Name");
          '15': Body := StrSubstNo(Body,AppEntry.FieldCaption("Due Date"));
          '16': Body := StrSubstNo(Body,AppEntry."Due Date");
          '17': Body := Text042;
          '18': Body := '';//STRSUBSTNO(Body,AppEntry."Available Credit Limit (LCY)");
        end;
    end;
}

