#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 6002 "Delete Service Document Log"
{
    Caption = 'Delete Service Document Log';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Service Document Log";"Service Document Log")
        {
            DataItemTableView = sorting("Change Date");
            RequestFilterFields = "Change Date","Document Type","Document No.";
            column(ReportForNavId_9020; 9020)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if not ProcessDeletedOnly then
                  CurrReport.Break;

                ServHeader.Reset;
                if (("Document Type" = "document type"::Order) or
                    ("Document Type" = "document type"::Invoice) or
                    ("Document Type" = "document type"::"Credit Memo") or
                    ("Document Type" = "document type"::Quote)) and not ServHeader.Get("Document Type","Document No.") or
                   ("Document Type" = "document type"::Shipment) and not ServShptHeader.Get("Document No.") or
                   ("Document Type" = "document type"::"Posted Invoice") and not ServInvHeader.Get("Document No.") or
                   ("Document Type" = "document type"::"Posted Credit Memo") and not ServCrMemoHeader.Get("Document No.")
                then begin
                  ServOrdLog.Reset;
                  ServOrdLog.SetRange("Document Type","Document Type");
                  ServOrdLog.SetRange("Document No.","Document No.");
                  LogEntryFiltered := ServOrdLog.Count;

                  LogEntryDeleted := LogEntryDeleted + LogEntryFiltered;
                  LogEntryProcessed := LogEntryProcessed + LogEntryFiltered;
                  ServOrdLog.DeleteAll;

                  Window.Update(2,LogEntryDeleted)
                end else
                  LogEntryProcessed := LogEntryProcessed + 1;

                Window.Update(1,LogEntryProcessed);
                Window.Update(3,ROUND(LogEntryProcessed / CounterTotal * 10000,1));
            end;

            trigger OnPostDataItem()
            begin
                if not HideConfirmationDlg then
                  if LogEntryDeleted > 1 then
                    Message(Text004,LogEntryDeleted)
                  else
                    Message(Text005,LogEntryDeleted);
            end;

            trigger OnPreDataItem()
            begin
                CounterTotal := Count;
                if ProcessDeletedOnly then begin
                  if not HideConfirmationDlg then
                    if not Confirm(Text006) then
                      CurrReport.Break;
                  Window.Open(Text007 + Text008 + Text009);
                  exit;
                end;
                if CounterTotal = 0 then begin
                  if not HideConfirmationDlg then
                    Message(Text000);
                  CurrReport.Break;
                end;
                if not HideConfirmationDlg then
                  if not Confirm(StrSubstNo(Text001,CounterTotal,TableCaption),false) then
                    Error(Text003);

                DeleteAll;
                LogEntryDeleted := CounterTotal;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ProcessDeletedOnly;ProcessDeletedOnly)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Delete Log Entries for Deleted Documents Only';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        OnPostReportStatus := false;
    end;

    trigger OnPostReport()
    begin
        OnPostReportStatus := true;
    end;

    var
        Text000: label 'There is nothing to delete.';
        Text001: label '%1 %2 records will be deleted.\\Do you want to continue?', Comment='10 Service Docuent Log record(s) will be deleted.\\Do you want to continue?';
        Text003: label 'No records were deleted.';
        Text004: label '%1 records were deleted.';
        Text005: label '%1 record was deleted.';
        ServHeader: Record "Service Header";
        ServShptHeader: Record "Service Shipment Header";
        ServInvHeader: Record "Service Invoice Header";
        ServCrMemoHeader: Record "Service Cr.Memo Header";
        ServOrdLog: Record "Service Document Log";
        Window: Dialog;
        LogEntryProcessed: Integer;
        LogEntryDeleted: Integer;
        LogEntryFiltered: Integer;
        CounterTotal: Integer;
        ProcessDeletedOnly: Boolean;
        HideConfirmationDlg: Boolean;
        Text006: label 'Do you want to delete the service order log entries for deleted service orders?';
        Text007: label 'Log entries processed: #1######\\';
        Text008: label 'Log entries deleted:   #2######\\';
        Text009: label '@3@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
        OnPostReportStatus: Boolean;


    procedure SetHideConfirmationDlg(HideDlg: Boolean)
    begin
        HideConfirmationDlg := HideDlg;
    end;


    procedure SetProcessDeletedOnly(DeletedOnly: Boolean)
    begin
        ProcessDeletedOnly := DeletedOnly;
    end;


    procedure GetServDocLog(var ServDocLog: Record "Service Document Log")
    begin
        ServDocLog.Copy("Service Document Log");
    end;


    procedure GetOnPostReportStatus(): Boolean
    begin
        exit(OnPostReportStatus and not ProcessDeletedOnly);
    end;
}

