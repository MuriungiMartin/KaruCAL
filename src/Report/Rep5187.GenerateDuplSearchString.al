#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5187 "Generate Dupl. Search String"
{
    Caption = 'Generate Dupl. Search String';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Contact;Contact)
        {
            DataItemTableView = where(Type=const(Company));
            RequestFilterFields = "No.","Company No.","Last Date Modified","External ID";
            column(ReportForNavId_6698; 6698)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(1);
                DuplMgt.MakeContIndex(Contact);
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
            end;

            trigger OnPreDataItem()
            begin
                Window.Open(Text000 +
                  Text001,"No.");
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Text000: label 'Processing contacts...\\';
        Text001: label 'Contact No.     #1##########';
        DuplMgt: Codeunit DuplicateManagement;
        Window: Dialog;
}

