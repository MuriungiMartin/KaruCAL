#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 65005 "Cash Sale Post"
{
    Caption = 'Cash Sale Header';
    DeleteAllowed = false;
    ModifyAllowed = true;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Invoice,Request Approval';
    RefreshOnActivate = true;
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type"=filter(Order),
                            "Cash Sale Order"=filter(true));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
            }
            group(Control1000000014)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    ToolTip = 'Specifies the number of the sales document. The field can be filled automatically or manually and can be set up to be invisible.';
                    Visible = false;

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                group("Sell-to")
                {
                    Caption = 'Sell-to';
                }
                field("Order Date";"Order Date")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    QuickEntry = false;
                    ToolTip = 'Specifies the date on which the exchange rate applies to prices listed in a foreign currency on the sales order.';
                    Visible = false;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies when the sales invoice must be paid.';
                    Visible = false;
                }
                field("Requested Delivery Date";"Requested Delivery Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date that the customer has asked for the order to be delivered.';
                    Visible = false;
                }
                field("Promised Delivery Date";"Promised Delivery Date")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the date that you have promised to deliver the order, as a result of the Order Promising function.';
                    Visible = false;
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ShowMandatory = ExternalDocNoMandatory;
                    ToolTip = 'Specifies the number that the customer uses in their own system to refer to this sales document.';
                    Visible = false;
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    QuickEntry = false;
                    ToolTip = 'Specifies the name of the salesperson who is assigned to the customer.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        SalespersonCodeOnAfterValidate;
                    end;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    AccessByPermission = TableData "Responsibility Center"=R;
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the code of the responsibility center that is associated with the user, company, or vendor.';
                    Visible = false;
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                    Visible = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    QuickEntry = false;
                    ToolTip = 'Specifies whether the document is open, waiting to be approved, has been invoiced for prepayment, or has been released to the next stage of processing.';
                    Visible = false;
                }
            }
            part(SalesLines;"Cash Sale Subform-Staff")
            {
                ApplicationArea = Basic,Suite;
                Editable = DynamicEditable;
                Enabled = "Sell-to Customer No." <> '';
                SubPageLink = "Document No."=field("No.");
                UpdatePropagation = Both;
                Visible = false;
            }
            group(Cost)
            {
                Caption = 'Cost';
                Visible = true;
                field("Cash Amount";"Cash Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cash Amount';

                    trigger OnValidate()
                    begin
                        CalcFields("Document Amount");
                        Balance:="Cash Amount"-"Document Amount";
                        //Rec.Balance :=Balances;
                        CurrPage.Update;
                    end;
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Paybill Amount";"Paybill Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Paybill Amount';
                    Visible = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Amount Paid";"Amount Paid")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;

                    trigger OnValidate()
                    begin
                        Rec.Balance:=Rec."Amount Paid"-Rec."Document Amount";
                        CurrPage.Update;
                    end;
                }
                field("Document Amount";"Document Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;

                    trigger OnValidate()
                    begin
                        Rec.Balance:=Rec."Amount Paid"-Rec."Document Amount";
                        CurrPage.Update;
                    end;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                    ToolTip = 'Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.';
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Enabled = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date you expect to ship items on the sales document.';
                    Visible = false;
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Enabled = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the date on which you created the sales document.';
                    Visible = false;
                }
            }
            group("Shipping and Billing")
            {
                Caption = 'Shipping and Billing';
                Visible = true;
                group(Control1000000022)
                {
                    group(Control1000000021)
                    {
                        field(ShippingOptions;ShipToOptions)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Ship-to';
                            ToolTip = 'Specifies the address that the products on the sales document are shipped to. Default (Sell-to Address): The same as the customer''s sell-to address. Alternate Ship-to Address: One of the customer''s alternate ship-to addresses. Custom Address: Any ship-to address that you specify in the fields below.';
                            Visible = false;

                            trigger OnValidate()
                            var
                                ShipToAddress: Record "Ship-to Address";
                                ShipToAddressList: Page "Ship-to Address List";
                            begin
                                case ShipToOptions of
                                  Shiptooptions::"Default (Sell-to Address)":
                                    begin
                                      Validate("Ship-to Code",'');
                                      CopySellToAddressToShipToAddress;
                                    end;
                                  Shiptooptions::"Alternate Shipping Address":
                                    begin
                                      ShipToAddress.SetRange("Customer No.","Sell-to Customer No.");
                                      ShipToAddressList.LookupMode := true;
                                      ShipToAddressList.SetTableview(ShipToAddress);

                                      if ShipToAddressList.RunModal = Action::LookupOK then begin
                                        ShipToAddressList.GetRecord(ShipToAddress);
                                        Validate("Ship-to Code",ShipToAddress.Code);
                                      end else
                                        ShipToOptions := Shiptooptions::"Custom Address";
                                    end;
                                  Shiptooptions::"Custom Address":
                                    Validate("Ship-to Code",'');
                                end;
                            end;
                        }
                    }
                    group("Shipment Method")
                    {
                        Caption = 'Shipment Method';
                        Visible = true;
                        field("Shipping No. Series";"Shipping No. Series")
                        {
                            ApplicationArea = Basic;
                        }
                        field("Posting No. Series";"Posting No. Series")
                        {
                            ApplicationArea = Basic;
                        }
                    }
                }
                group(Control1000000016)
                {
                    Visible = false;
                    field(BillToOptions;BillToOptions)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Bill-to';
                        ToolTip = 'Specifies the customer that the sales invoice will be sent to. Default (Customer): The same as the customer on the sales invoice. Another Customer: Any customer that you specify in the fields below.';

                        trigger OnValidate()
                        begin
                            if BillToOptions = Billtooptions::"Default (Customer)" then
                              Validate("Bill-to Customer No.","Sell-to Customer No.");
                        end;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Post)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    trigger OnAction()
                    var
                        DepositHeader: Record UnknownRecord10140;
                        DepositLines: Record "Gen. Journal Line";
                        SalesShipmentHeader: Record "Sales Shipment Header";
                        SalesHeader: Record "Sales Header";
                        SalesLine: Record "Sales Line";
                        TotalLineAmount: Decimal;
                        LineNo: Integer;
                        AlreadyUsedTillNumbers: Record UnknownRecord70086;
                        MpesaTransNoUsed: Code[50];
                        DocsNos: Code[20];
                        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
                    begin
                        //Rec.Status:=Status::Released;
                        Clear(TotalLineAmount);
                        Rec.CalcFields("Document Amount");

                        if ((Rec."Cash Amount"+Rec."Paybill Amount")<Rec."Document Amount") then Error('Amount is less than Document Amount!');

                        //IF Rec."Amount Paid"<>Rec."Document Amount" THEN ERROR('Total Amount Paid should be equal to: '+FORMAT(Rec."Document Amount"));
                        //Rec.TESTFIELD(Rec."Bal. Account No.");

                          if Rec."Payment Method" = Rec."payment method"::Mpesa then
                            Rec.TestField("Paybill Amount");
                        if Rec."Paybill Amount"<>0 then
                            Rec.TestField("Till Number");
                        MpesaBankAccountsSetup.Reset;
                        MpesaBankAccountsSetup.SetRange("Mpesa Code","Till Number");
                        if MpesaBankAccountsSetup.Find('-') then begin
                          if Rec."Paybill Amount"<>0 then begin
                            MpesaBankAccountsSetup.TestField("Bank Account Code");
                            end;
                          end;
                          if Rec."Paybill Amount"<>0 then begin
                        Clear(AlreadyUsedTillNumbers);
                        Clear(MpesaTransNoUsed);
                        MpesaTransNoUsed:=Rec."M-Pesa Transaction Number";
                        AlreadyUsedTillNumbers.Reset;
                        AlreadyUsedTillNumbers.SetRange("Transaction No.",MpesaTransNoUsed);
                        if AlreadyUsedTillNumbers.Find('-') then Error('Transaction Number already used on: '+AlreadyUsedTillNumbers."Invoice Number Applied");
                        end;

                        if Location.Get(Rec."Location Code") then begin
                          end;
                          if Rec."Paybill Amount"<>0 then
                            Rec.TestField("M-Pesa Transaction Number");
                           if Rec."Payment Method" = Rec."payment method"::Advance then
                           Error('Advance is not activated')
                          else if Rec."Payment Method" = Rec."payment method"::Credit then
                            Error('Credit is not activated');

                        if Confirm('Post?',true)=false then exit;
                        Clear(BankAccountLedgerEntry);
                        BankAccountLedgerEntry.Reset;
                        BankAccountLedgerEntry.SetRange("Sales Order No",Rec."No.");
                        if BankAccountLedgerEntry.Find('-') then Error('Document already Posted!');
                        // Get Document Number Here
                        //Get Amount Paid and Change Too
                        // Create a Depisit Entry
                        SalesLine.Reset;
                        SalesLine.SetRange(SalesLine."Document No.",Rec."No.");
                        //salesline.SETFILTER(SalesLine.Amount,'=%1',0);
                        //IF salesline.FIND('-') THEN ERROR('All Line must have quantity');
                        if SalesLine.Find('-') then begin
                          repeat
                              begin
                              TotalLineAmount:=TotalLineAmount+SalesLine.Amount;
                              end;
                            until SalesLine.Next=0;

                        if TotalLineAmount>0 then begin
                              if not FINCashOfficeUserTemplate.Get(UserId) then Error('Access to receipting denied!');
                        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Direct Cash Sale Bank");
                        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Direct Sales Inv. Nos.");
                        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Cash Receipt No. Series");
                        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Default Direct Sale Customer");
                        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Direct Sales External Doc. Nos");
                        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Default Direct Sales Location");
                        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Direct Sales Item Category");
                        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Direct Cash Sale Deposit Nos.");
                        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Petty Cash Template");
                        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Petty Cash Batch");

                        if Rec."Payment Method" = Rec."payment method"::Mpesa then;
                        //FINCashOfficeUserTemplate.TESTFIELD(FINCashOfficeUserTemplate."Direct  Cash Sale Paybill");

                        Rec.CalcFields("Document Amount");
                        Clear(DepositLines);
                        DepositLines.Reset;
                        DepositLines.SetRange(DepositLines."Journal Template Name",FINCashOfficeUserTemplate."Petty Cash Template");
                        DepositLines.SetRange(DepositLines."Journal Batch Name",FINCashOfficeUserTemplate."Petty Cash Batch");
                        if DepositLines.Find('-') then DepositLines.DeleteAll;

                        Clear(DepositHeader);
                        DepositHeader.Reset;
                        DepositHeader.SetRange("Journal Template Name",FINCashOfficeUserTemplate."Petty Cash Template");
                        DepositHeader.SetRange("Journal Batch Name",FINCashOfficeUserTemplate."Petty Cash Batch");
                        if DepositHeader.Find('-') then DepositHeader.DeleteAll;

                        // Post Cash Amount
                        if Rec."Cash Amount">0 then begin
                        // Insert Lines
                        LineNo:=10000;
                        DepositLines.Init;
                        DepositLines."Journal Template Name":=FINCashOfficeUserTemplate."Petty Cash Template";
                        DepositLines."Journal Batch Name":=FINCashOfficeUserTemplate."Petty Cash Batch";
                        DepositLines."Line No.":=LineNo+1000;
                        DepositLines."Account Type":=DepositLines."account type"::Customer;
                        DepositLines."Account No.":=FINCashOfficeUserTemplate."Default Direct Sale Customer";
                        DepositLines."Posting Date":=Rec."Posting Date";
                        DepositLines."Document Type":=DepositLines."document type"::Payment;
                        DepositLines."Document No.":=NoSeriesMgt.GetNextNo(FINCashOfficeUserTemplate."Direct Cash Sale Deposit Nos.",Today,true);;
                        DepositLines.Description:='POS Cash Sales Receipt No.';
                        DepositLines."Bal. Account Type":=DepositLines."bal. account type"::"Bank Account";
                        //IF Location."Direct Cash Sale Bank"<>'' THEN BEGIN
                        //DepositLines."Bal. Account No.":=Location."Direct Cash Sale Bank";
                        //END ELSE BEGIN
                        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Direct Cash Sale Bank");
                        //
                        //  IF Rec."Paybill Amount"<>0 THEN
                        // DepositLines."Bal. Account No.":=MpesaBankAccountsSetup."Bank Account Code" ELSE
                        DepositLines."Bal. Account No.":=FINCashOfficeUserTemplate."Direct Cash Sale Bank";
                        //  END;
                        DepositLines."Credit Amount":=Rec."Document Amount";//TotalLineAmount;
                        DepositLines.Validate(DepositLines."Credit Amount");
                        DepositLines."Applies-to ID":=DepositHeader."No.";
                        DepositLines."Allow Application":=true;
                        DepositLines."Document Date":=Today;
                        DepositLines."External Document No.":=Rec."No.";//DepositLines."Document No.";
                        DepositLines."User ID":=UserId;
                        DepositLines."Applied Automatically":=true;
                        DepositLines."Shortcut Dimension 1 Code":=FINCashOfficeUserTemplate."Shortcut Dimension 1 Code";
                        DepositLines."Shortcut Dimension 2 Code":=FINCashOfficeUserTemplate."Shortcut Dimension 2 Code";

                        DepositLines.Insert(true);

                        DepositHeader.Init;
                        DepositHeader."No.":=DepositLines."Document No.";
                        //IF Location."Direct Cash Sale Bank"<>'' THEN BEGIN
                        //DepositHeader."Bank Account No.":=Location."Direct Cash Sale Bank";
                        //END ELSE BEGIN
                        //  IF Rec."Payment Method" = Rec."Payment Method"::Mpesa THEN
                        // DepositHeader."Bank Account No.":=MpesaBankAccountsSetup."Bank Account Code" ELSE
                        DepositHeader."Bank Account No.":=FINCashOfficeUserTemplate."Direct Cash Sale Bank";
                        DepositHeader.Validate(DepositHeader."Bank Account No.");
                        //END;
                        DepositHeader."Posting Date":=Today;
                        DepositHeader.Validate(DepositHeader."Posting Date");
                        DepositHeader."Total Deposit Amount":=Rec."Document Amount";//"Cash Amount";
                        //DepositHeader."Total Deposit Amount"
                        DepositHeader."Document Date":=Today;
                        //DepositHeader."Bank Acc. Posting Group":=
                        DepositHeader."No. Series":=FINCashOfficeUserTemplate."Direct Cash Sale Deposit Nos.";
                        DepositHeader."Posting Description":='POS Cash Sales Receipt No.';
                        DepositHeader."Journal Template Name":=FINCashOfficeUserTemplate."Petty Cash Template";
                        DepositHeader."Journal Batch Name":=FINCashOfficeUserTemplate."Petty Cash Batch";
                        DepositHeader."Direct Sale":=true;
                        //DepositHeader.Comment:='Cash Sale '+DepositHeader."No.";
                        DepositHeader.Insert(true);

                        Rec."Deposit Slip No":=DepositHeader."No.";
                        Rec."Deposit No.":=DepositHeader."No.";
                        Rec.Modify;

                        //Post(CODEUNIT::"Sales-Post (Yes/No)",NavigateAfterPost::"Posted Document");
                        //Post Deposit Into the Petty Cash Account

                        end;// End Cash Posting
                        if DepositHeader.Find('-') then
                          if DepositHeader."Total Deposit Amount">0 then begin
                            // Post(CODEUNIT::"Sales-Post (Yes/No)",NavigateAfterPost::"Posted Document");
                             Codeunit.Run(Codeunit::"Deposit-Post (Yes/No)",DepositHeader);
                             end;
                        //Post Paybill Amounts Here
                        if Rec."Paybill Amount">0 then begin
                           // Insert Lines
                        // DepositLines.RESET;
                        // DepositLines.SETRANGE(DepositLines."Journal Template Name",FINCashOfficeUserTemplate."Petty Cash Template");
                        // DepositLines.SETRANGE(DepositLines."Journal Batch Name",FINCashOfficeUserTemplate."Petty Cash Batch");
                        // IF DepositLines.FIND('-') THEN DepositLines.DELETEALL;
                        LineNo:=10000;
                        DepositLines.Init;
                        DepositLines."Journal Template Name":=FINCashOfficeUserTemplate."Petty Cash Template";
                        DepositLines."Journal Batch Name":=FINCashOfficeUserTemplate."Petty Cash Batch";
                        DepositLines."Line No.":=LineNo+1000;
                        DepositLines."Account Type":=DepositLines."account type"::Customer;
                        DepositLines."Account No.":=FINCashOfficeUserTemplate."Default Direct Sale Customer";
                        DepositLines."Posting Date":=Rec."Posting Date";
                        DepositLines."Document Type":=DepositLines."document type"::Payment;
                        DepositLines."Document No.":=Rec."M-Pesa Transaction Number";NoSeriesMgt.GetNextNo(FINCashOfficeUserTemplate."Direct Cash Sale Deposit Nos.",TODAY,TRUE);
                        DepositLines.Description:='POS Cash Sales Receipt No.';
                        DepositLines."Bal. Account Type":=DepositLines."bal. account type"::"Bank Account";
                        //IF Location."Direct  Cash Sale Paybill"<>'' THEN BEGIN
                        //DepositLines."Bal. Account No.":=Location."Direct  Cash Sale Paybill";
                        //END ELSE BEGIN
                        //FINCashOfficeUserTemplate.TESTFIELD(FINCashOfficeUserTemplate."Direct  Cash Sale Paybill");
                        DepositLines."Bal. Account No.":=MpesaBankAccountsSetup."Bank Account Code";
                        //END;
                        if Rec."Cash Amount">Rec."Document Amount" then Error('Cash amount was enough to settle the bill');
                        DepositLines."Credit Amount":=Rec."Document Amount"-Rec."Cash Amount";//TotalLineAmount;
                        DepositLines.Validate(DepositLines."Credit Amount");
                        DepositLines."Applies-to ID":=DepositHeader."No.";
                        DepositLines."Allow Application":=true;
                        DepositLines."Document Date":=Today;
                        DepositLines."External Document No.":=Rec."No.";//DepositLines."Document No.";
                        DepositLines."User ID":=UserId;
                        DepositLines."Applied Automatically":=true;
                        DepositLines."Shortcut Dimension 1 Code":=FINCashOfficeUserTemplate."Shortcut Dimension 1 Code";
                        DepositLines."Shortcut Dimension 2 Code":=FINCashOfficeUserTemplate."Shortcut Dimension 2 Code";

                        DepositLines.Insert(true);
                        DepositHeader.Init;
                        DepositHeader."No.":=Rec."M-Pesa Transaction Number";;//DepositLines."Document No.";
                        //IF Location."Direct  Cash Sale Paybill"<>'' THEN BEGIN
                        //DepositLines."Bal. Account No.":=Location."Direct  Cash Sale Paybill";
                         // DepositHeader.VALIDATE(DepositHeader."Bank Account No.");
                        //END ELSE BEGIN
                        DepositHeader."Bank Account No.":=MpesaBankAccountsSetup."Bank Account Code";//FINCashOfficeUserTemplate."Direct  Cash Sale Paybill";
                        DepositHeader.Validate(DepositHeader."Bank Account No.");
                        //END;
                        DepositHeader."Posting Date":=Today;
                        DepositHeader.Validate(DepositHeader."Posting Date");
                        DepositHeader."Total Deposit Amount":=Rec."Paybill Amount";;
                        //DepositHeader."Total Deposit Amount"
                        DepositHeader."Document Date":=Today;
                        //DepositHeader."Bank Acc. Posting Group":=
                        DepositHeader."No. Series":=FINCashOfficeUserTemplate."Direct Cash Sale Deposit Nos.";
                        DepositHeader."Posting Description":='POS Mpesa Sales Receipt No.';
                        DepositHeader."Journal Template Name":=FINCashOfficeUserTemplate."Petty Cash Template";
                        DepositHeader."Journal Batch Name":=FINCashOfficeUserTemplate."Petty Cash Batch";
                        DepositHeader."Direct Sale":=true;
                        //DepositHeader.Comment:='Cash Sale '+DepositHeader."No.";
                        DepositHeader.Insert(true);

                        Rec."Deposit Slip No":=DepositLines."Document No.";
                        Rec."Deposit No.":=DepositLines."Document No.";
                        Rec.Modify;

                        //Post Deposit Into the Petty Cash Account
                        Codeunit.Run(Codeunit::"Deposit-Post (Yes/No)",DepositHeader);
                          end;

                        Post(Codeunit::"Sales-Post (Yes/No)",Navigateafterpost::"Posted Document");
                          // Backup of the Uniques Mpesa Number
                            if Rec."Paybill Amount"<>0 then begin
                            AlreadyUsedTillNumbers.Init;
                            AlreadyUsedTillNumbers."Invoice Number Applied":=Rec."No.";
                            AlreadyUsedTillNumbers."Till Number":=Rec."Till Number";
                            AlreadyUsedTillNumbers."Transaction No.":="M-Pesa Transaction Number";
                            AlreadyUsedTillNumbers.Insert(true);
                            end;
                        //Rec.Status:=Rec.Status::Released;
                        //Rec.MODIFY;
                        // Print Receipt
                        SalesShipmentHeader.Reset;
                        SalesShipmentHeader.SetRange(SalesShipmentHeader."Order No.",xRec."No.");
                        if SalesShipmentHeader.Find('-') then begin
                           // Load and Print Receipt Here
                          Report.Run(65000,false,true,SalesShipmentHeader);
                          end;
                        end;
                        end;
                    end;
                }
                action(PostAndNew)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post and New';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Category6;
                    ShortCutKey = 'Shift+F9';
                    Visible = false;

                    trigger OnAction()
                    begin
                        Post(Codeunit::"Sales-Post (Yes/No)",Navigateafterpost::"New Document");
                    end;
                }
                action(PostAndSend)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Post and Send';
                    Ellipsis = true;
                    Image = PostMail;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedOnly = true;
                    ToolTip = 'Finalize and prepare to send the document according to the customer''s sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.';
                    Visible = false;

                    trigger OnAction()
                    begin
                        Post(Codeunit::"Sales-Post and Send",Navigateafterpost::Nowhere);
                    end;
                }
                action("Test Report")
                {
                    ApplicationArea = Basic;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';
                    Visible = false;

                    trigger OnAction()
                    begin
                        ReportPrint.PrintSalesHeader(Rec);
                    end;
                }
                action("Remove From Job Queue")
                {
                    ApplicationArea = All;
                    Caption = 'Remove From Job Queue';
                    Image = RemoveLine;
                    ToolTip = 'Remove the scheduled processing of this record from the job queue.';
                    Visible = false;

                    trigger OnAction()
                    begin
                        CancelBackgroundPosting;
                    end;
                }
                action(PreviewPosting)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Preview Posting';
                    Image = ViewPostedOrder;
                    ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';
                    Visible = false;

                    trigger OnAction()
                    begin
                        ShowPreview;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
    begin
        DynamicEditable := CurrPage.Editable;
        //CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
        CRMIsCoupledToRecord := CRMIntegrationEnabled and CRMCouplingManagement.IsRecordCoupledToCRM(RecordId);
        //ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(RECORDID);

        UpdatePaymentService;
    end;

    trigger OnAfterGetRecord()
    begin
        SetControlVisibility;
        UpdateShipToBillToGroupVisibility;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord;
        exit(ConfirmDeletion);
    end;

    trigger OnInit()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SetExtDocNoMandatoryCondition;

        JobQueuesUsed := SalesReceivablesSetup."Post & Print with Job Queue" or SalesReceivablesSetup."Post with Job Queue";
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if not FINCashOfficeUserTemplate.Get(UserId) then Error('Access to receipting denied!');
        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Direct Cash Sale Bank");
        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Direct Sales Inv. Nos.");
        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Cash Receipt No. Series");
        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Default Direct Sale Customer");
        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Direct Sales External Doc. Nos");
        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Default Direct Sales Location");
        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Direct Sales Item Category");
        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Direct Cash Sale Deposit Nos.");

        //"Cash Sale Order":=TRUE;
          if "No." = '' then begin
          "No." :=NoSeriesMgt.GetNextNo(FINCashOfficeUserTemplate."Cash Receipt No. Series",Today,true);
        end;
        "Sell-to Customer No.":=FINCashOfficeUserTemplate."Default Direct Sale Customer";
        Validate("Sell-to Customer No.");
        "Order Date":=Today;
        "Posting Date":=Today;
        "Shipment Date":=Today;
        //"Bal. Account Type":="Bal. Account Type"::"Bank Account";
        //"Bal. Account No.":=FINCashOfficeUserTemplate."Direct Cash Sale Bank";
        //"Payment Type":="Payment Type"::Cash;
        //VALIDATE("Payment Type");

        "Posting Description":='Sales '+FINCashOfficeUserTemplate.User_ID+','+FINCashOfficeUserTemplate."Default Direct Sales Location"+','+FINCashOfficeUserTemplate."Direct Sales Item Category";
        "Due Date":=Today;
        "Location Code":=FINCashOfficeUserTemplate."Default Direct Sales Location";
        "Document Date":=Today;
        "External Document No.":=NoSeriesMgt.GetNextNo(FINCashOfficeUserTemplate."Direct Sales External Doc. Nos",Today,true);
        "Requested Delivery Date":=Today;
         "Shortcut Dimension 1 Code":=FINCashOfficeUserTemplate."Shortcut Dimension 1 Code";
         "Shortcut Dimension 2 Code":=FINCashOfficeUserTemplate."Shortcut Dimension 2 Code";
         //"Payment Period":=FINCashOfficeUserTemplate."Shortcut Dimension 3 Code";
        if DocNoVisible then
          CheckCreditMaxBeforeInsert;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if not FINCashOfficeUserTemplate.Get(UserId) then Error('Access to receipting denied!');
        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Direct Cash Sale Bank");
        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Direct Sales Inv. Nos.");
        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Cash Receipt No. Series");
        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Default Direct Sale Customer");
        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Direct Sales External Doc. Nos");
        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Default Direct Sales Location");
        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Direct Sales Item Category");
        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Direct Cash Sale Deposit Nos.");

        "Cash Sale Order":=true;
          if "No." = '' then begin
          "No." :=NoSeriesMgt.GetNextNo(FINCashOfficeUserTemplate."Cash Receipt No. Series",Today,true);
        end;
        "Sell-to Customer No.":=FINCashOfficeUserTemplate."Default Direct Sale Customer";
        Validate("Sell-to Customer No.");
        "Order Date":=Today;
        "Posting Date":=Today;
        "Shipment Date":=Today;
        //"Bal. Account Type":="Bal. Account Type"::"Bank Account";
        //"Bal. Account No.":=FINCashOfficeUserTemplate."Direct Cash Sale Bank";

        //"Payment Type":="Payment Type"::Cash;
        //VALIDATE("Period Year");
        "Posting Description":=CopyStr(('Cafe Cash '+FINCashOfficeUserTemplate.User_ID+','+FINCashOfficeUserTemplate."Default Direct Sales Location"+','+FINCashOfficeUserTemplate."Direct Sales Item Category"),1,70);
        "Due Date":=Today;
        "Location Code":=FINCashOfficeUserTemplate."Default Direct Sales Location";
        "Document Date":=Today;
        "External Document No.":=NoSeriesMgt.GetNextNo(FINCashOfficeUserTemplate."Direct Sales External Doc. Nos",Today,true);
        "Requested Delivery Date":=Today;
        //Status:=Status::Released;
        "Responsibility Center" := UserMgt.GetSalesFilter;
        if (not DocNoVisible) and ("No." = '') then
          SetSellToCustomerFromFilter;

        SetDefaultPaymentServices;
    end;

    trigger OnOpenPage()
    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        OfficeMgt: Codeunit "Office Management";
    begin
        if UserMgt.GetSalesFilter <> '' then begin
          FilterGroup(2);
          SetRange("Responsibility Center",UserMgt.GetSalesFilter);
          FilterGroup(0);
        end;

        SetRange("Date Filter",0D,WorkDate - 1);

        SetDocNoVisible;

        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
        IsOfficeHost := OfficeMgt.IsAvailable;
        Rec.CalcFields(Amount,"Document Amount");
        "Cash Amount":="Document Amount";

        if "Quote No." <> '' then
          ShowQuoteNo := true;
        Clear(Balance);
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if not DocumentIsPosted then
          exit(ConfirmCloseUnposted);
    end;

    var
        MpesaBankAccountsSetup: Record UnknownRecord99909;
        ApplicationAreaSetup: Record "Application Area Setup";
        CopySalesDoc: Report "Copy Sales Document";
        MoveNegSalesLines: Report "Move Negative Sales Lines";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ReportPrint: Codeunit "Test Report-Print";
        DocPrint: Codeunit "Document-Print";
        ArchiveManagement: Codeunit ArchiveManagement;
        SalesCalcDiscountByType: Codeunit "Sales - Calc Discount By Type";
        UserMgt: Codeunit "User Setup Management";
        ChangeExchangeRate: Page "Change Exchange Rate";
        Usage: Option "Order Confirmation","Work Order","Pick Instruction";
        NavigateAfterPost: Option "Posted Document","New Document",Nowhere;
        [InDataSet]
        JobQueueVisible: Boolean;
        Text001: label 'Do you want to change %1 in all related records in the warehouse?';
        Text002: label 'The update has been interrupted to respect the warning.';
        DynamicEditable: Boolean;
        HasIncomingDocument: Boolean;
        DocNoVisible: Boolean;
        ExternalDocNoMandatory: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
        ShowWorkflowStatus: Boolean;
        IsOfficeHost: Boolean;
        CanCancelApprovalForRecord: Boolean;
        JobQueuesUsed: Boolean;
        ShowQuoteNo: Boolean;
        DocumentIsPosted: Boolean;
        OpenPostedSalesOrderQst: label 'The order has been posted and moved to the Posted Sales Invoices window.\\Do you want to open the posted invoice?';
        PaymentServiceVisible: Boolean;
        PaymentServiceEnabled: Boolean;
        ShipToOptions: Option "Default (Sell-to Address)","Alternate Shipping Address","Custom Address";
        BillToOptions: Option "Default (Customer)","Another Customer";
        EmptyShipToCodeErr: label 'The Code field can only be empty if you select Custom Address in the Ship-to field.';
        FINCashOfficeUserTemplate: Record UnknownRecord61712;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        BankNo: Code[20];
        Location: Record Location;

    local procedure Post(PostingCodeunitID: Integer;Navigate: Option)
    var
        SalesHeader: Record "Sales Header";
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
        InstructionMgt: Codeunit "Instruction Mgt.";
    begin
        if ApplicationAreaSetup.IsFoundationEnabled then
          LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);

        SendToPosting(PostingCodeunitID);
        DocumentIsPosted := not SalesHeader.Get("Document Type","No.");

        if "Job Queue Status" = "job queue status"::"Scheduled for Posting" then
          CurrPage.Close;
        CurrPage.Update(false);

        if PostingCodeunitID <> Codeunit::"Sales-Post (Yes/No)" then
          exit;

        case Navigate of
         // NavigateAfterPost::"Posted Document":
          //  IF InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode) THEN
            //  ShowPostedConfirmationMessage;
          Navigateafterpost::"New Document":
            if DocumentIsPosted then begin
              //SalesHeader.INIT;
              //SalesHeader.VALIDATE("Cash Sale Order",TRUE);
              //SalesHeader.VALIDATE("Document Type",SalesHeader."Document Type"::Order);
              //SalesHeader.INSERT(TRUE);
              if not FINCashOfficeUserTemplate.Get(UserId) then Error('Access to receipting denied!');
        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Direct Cash Sale Bank");
        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Direct Sales Inv. Nos.");
        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Cash Receipt No. Series");
        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Default Direct Sale Customer");
        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Direct Sales External Doc. Nos");
        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Default Direct Sales Location");
        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Direct Sales Item Category");
        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Direct Cash Sale Deposit Nos.");
        SalesHeader.Init;
        SalesHeader."Cash Sale Order":=true;
          //IF SalesHeader."No." = '' THEN BEGIN
        SalesHeader."No.":=NoSeriesMgt.GetNextNo(FINCashOfficeUserTemplate."Cash Receipt No. Series",Today,true);
        //END;
        //SalesHeader."Sell-to Customer No.":=FINCashOfficeUserTemplate."Default Direct Sale Customer";
        //VALIDATE("Sell-to Customer No.");
        SalesHeader."Order Date":=Today;
        SalesHeader."Posting Date":=Today;
        SalesHeader."Shipment Date":=Today;
        SalesHeader."Posting Description":='Sales '+FINCashOfficeUserTemplate.User_ID+','+FINCashOfficeUserTemplate."Default Direct Sales Location"+','+FINCashOfficeUserTemplate."Direct Sales Item Category";
        SalesHeader."Due Date":=Today;
        "Location Code":=FINCashOfficeUserTemplate."Default Direct Sales Location";
        SalesHeader."Document Date":=Today;
        SalesHeader."External Document No.":=NoSeriesMgt.GetNextNo(FINCashOfficeUserTemplate."Direct Sales External Doc. Nos",Today,true);
        SalesHeader."Requested Delivery Date":=Today;

        SalesHeader."Responsibility Center" := UserMgt.GetSalesFilter;
        SalesHeader.Insert;
              Page.Run(Page::"Cash Sale Header-Staff",SalesHeader);
            end;
        end;
    end;

    local procedure ApproveCalcInvDisc()
    begin
        CurrPage.SalesLines.Page.ApproveCalcInvDisc;
    end;

    local procedure SalespersonCodeOnAfterValidate()
    begin
        CurrPage.SalesLines.Page.UpdateForm(true);
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.Update;
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        CurrPage.Update;
    end;

    local procedure Prepayment37OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(Doctype::Order,"No.");
    end;

    local procedure SetExtDocNoMandatoryCondition()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get;
        ExternalDocNoMandatory := SalesReceivablesSetup."Ext. Doc. No. Mandatory"
    end;

    local procedure ShowPreview()
    var
        SalesPostYesNo: Codeunit "Sales-Post (Yes/No)";
    begin
        SalesPostYesNo.Preview(Rec);
    end;

    local procedure SetControlVisibility()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        JobQueueVisible := "Job Queue Status" = "job queue status"::"Scheduled for Posting";
        HasIncomingDocument := "Incoming Document Entry No." <> 0;
        SetExtDocNoMandatoryCondition;

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RecordId);
    end;

    local procedure ShowPostedConfirmationMessage()
    var
        OrderSalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        InstructionMgt: Codeunit "Instruction Mgt.";
    begin
        if not OrderSalesHeader.Get("Document Type","No.") then begin
          SalesInvoiceHeader.SetRange("No.","Last Posting No.");
          if SalesInvoiceHeader.FindFirst then
            if InstructionMgt.ShowConfirm(OpenPostedSalesOrderQst,InstructionMgt.ShowPostedConfirmationMessageCode) then
              Page.Run(Page::"Posted Sales Invoice",SalesInvoiceHeader);
        end;
    end;

    local procedure UpdatePaymentService()
    var
        PaymentServiceSetup: Record "Payment Service Setup";
    begin
        PaymentServiceVisible := PaymentServiceSetup.IsPaymentServiceVisible;
        PaymentServiceEnabled := PaymentServiceSetup.CanChangePaymentService(Rec);
    end;

    local procedure UpdateShipToBillToGroupVisibility()
    begin
        case true of
          ("Ship-to Code" = '') and ShipToAddressEqualsSellToAddress:
            ShipToOptions := Shiptooptions::"Default (Sell-to Address)";
          ("Ship-to Code" = '') and (not ShipToAddressEqualsSellToAddress):
            ShipToOptions := Shiptooptions::"Custom Address";
          "Ship-to Code" <> '':
            ShipToOptions := Shiptooptions::"Alternate Shipping Address";
        end;

        if "Bill-to Customer No." = "Sell-to Customer No." then
          BillToOptions := Billtooptions::"Default (Customer)"
        else
          BillToOptions := Billtooptions::"Another Customer";
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeStatisticsAction(var SalesHeader: Record "Sales Header";var Handled: Boolean)
    begin
    end;
}

