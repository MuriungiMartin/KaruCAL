#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10084 "Void/Transmit Elec. Payments"
{
    Caption = 'Void/Transmit Electronic Payments';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Gen. Journal Line";"Gen. Journal Line")
        {
            DataItemTableView = sorting("Journal Template Name","Journal Batch Name","Line No.") where("Document Type"=filter(Payment|Refund),"Bank Payment Type"=filter("Electronic Payment"|"Electronic Payment-IAT"),"Check Printed"=const(true),"Check Exported"=const(true),"Check Transmitted"=const(false));
            column(ReportForNavId_7024; 7024)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if "Account Type" = "account type"::"Bank Account" then begin
                  if "Account No." <> BankAccount."No." then
                    CurrReport.Skip;
                end else
                  if "Bal. Account Type" = "bal. account type"::"Bank Account" then begin
                    if "Bal. Account No." <> BankAccount."No." then
                      CurrReport.Skip;
                  end else
                    CurrReport.Skip;

                if FirstTime then begin
                  FileName := BankAccount."E-Pay Export File Path" + "Export File Name";
                  case UsageType of
                    Usagetype::Void:
                      begin
                        if RBMgt.ClientFileExists(FileName) then
                          RBMgt.DeleteClientFile(FileName)
                        else
                          Error(Text001,FileName);
                      end;
                    Usagetype::Transmit:
                      begin
                        if not RTCConfirmTransmit then
                          exit;
                        if RBMgt.ClientFileExists(FileName) then begin
                          case BankAccount."Export Format" of
                            BankAccount."export format"::US:
                              ExportPaymentsACH.TransmitExportedFile(BankAccount."No.","Export File Name");
                            BankAccount."export format"::CA:
                              ExportPaymentsRB.TransmitExportedFile(BankAccount."No.","Export File Name");
                            BankAccount."export format"::MX:
                              ExportPaymentsCecoban.TransmitExportedFile(BankAccount."No.","Export File Name");
                            else
                              Error(
                                Text002,
                                BankAccount."Export Format",
                                BankAccount.FieldCaption("Export Format"),
                                BankAccount.TableCaption,
                                BankAccount."No.");
                          end;
                          if RBMgt.ClientFileExists(FileName) then begin
                            CurrReport.Quit;
                            exit;
                          end;
                        end else
                          Error(Text003,FileName);
                      end;
                  end;
                  FirstTime := false;
                end;
                CheckManagement.ProcessElectronicPayment("Gen. Journal Line",UsageType);

                if UsageType = Usagetype::Void then begin
                  "Check Exported" := false;
                  "Check Printed" := false;
                  "Document No." := '';
                end else
                  "Check Transmitted" := true;

                Modify;
            end;

            trigger OnPreDataItem()
            begin
                FirstTime := true;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field("BankAccount.""No.""";BankAccount."No.")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Bank Account No.';
                        TableRelation = "Bank Account";
                        ToolTip = 'Specifies the bank account that the payment is transmitted to.';
                    }
                    field(DisplayUsageType;DisplayUsageType)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'E-Pay Operation';
                        Editable = false;
                        OptionCaption = ',Void,Transmit';
                        ToolTip = 'Specifies if you want to transmit or void the electronic payment file. The Transmit option produces an electronic payment file to be transmitted to your bank for processing. The Void option voids the exported file. Confirm that the correct selection has been made before you process the electronic payment file.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            DisplayUsageType := UsageType;
            if DisplayUsageType = 0 then
              Error(Text004);
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        with BankAccount do begin
          Get("No.");
          TestField(Blocked,false);
          TestField("Currency Code",'');  // local currency only
          TestField("Export Format");

          if UsageType <> Usagetype::Transmit then
            if not Confirm(Text000,
                 false,
                 UsageType,
                 TableCaption,
                 "No.")
            then
              CurrReport.Quit;
        end;
    end;

    var
        BankAccount: Record "Bank Account";
        CheckManagement: Codeunit CheckManagement;
        ExportPaymentsACH: Codeunit "Export Payments (ACH)";
        ExportPaymentsRB: Codeunit "Export Payments (RB)";
        ExportPaymentsCecoban: Codeunit "Export Payments (Cecoban)";
        RBMgt: Codeunit "File Management";
        FileName: Text;
        FirstTime: Boolean;
        UsageType: Option ,Void,Transmit;
        DisplayUsageType: Option ,Void,Transmit;
        Text000: label 'Are you SURE you want to %1 all of the Electronic Payments written against %2 %3?';
        Text001: label 'The export file, %1, has already been transmitted. You can no longer void these entries.';
        Text002: label '%1 is not a valid %2 in %3 %4.';
        Text003: label 'The export file, %1, has already been transmitted.';
        Text004: label 'This process can only be run from the Payment Journal';
        Text005: label 'Has export file, %1, been successfully transmitted?';


    procedure SetUsageType(NewUsageType: Option ,Void,Transmit)
    begin
        UsageType := NewUsageType;
    end;


    procedure RTCConfirmTransmit(): Boolean
    begin
        if not Confirm(Text005,false,FileName) then
          exit(false);

        exit(true);
    end;
}

