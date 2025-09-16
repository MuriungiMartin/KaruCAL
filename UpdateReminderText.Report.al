#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 187 "Update Reminder Text"
{
    Caption = 'Update Reminder Text';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Reminder Header";"Reminder Header")
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_4775; 4775)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ReminderHeader.Get("No.");
                if ReminderLevel.Get(ReminderHeader."Reminder Terms Code",ReminderLevelNo) then begin
                  ReminderHeader."Reminder Level" := ReminderLevelNo;
                  ReminderHeader.Modify;
                  ReminderHeader.UpdateLines(ReminderHeader,UpdateAdditionalFee);
                end
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
                    field(ReminderLevelNo;ReminderLevelNo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Reminder Level';
                    }
                    field(UpdateAdditionalFee;UpdateAdditionalFee)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Update Additional Fee';
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

    var
        ReminderHeader: Record "Reminder Header";
        ReminderLevel: Record "Reminder Level";
        ReminderLevelNo: Integer;
        UpdateAdditionalFee: Boolean;
}

