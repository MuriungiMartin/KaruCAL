#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5184 "Apply Mailing Group"
{
    Caption = 'Apply Mailing Group';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Contact Mailing Group";"Contact Mailing Group")
        {
            DataItemTableView = sorting("Mailing Group Code");
            column(ReportForNavId_6043; 6043)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Delete;
            end;

            trigger OnPreDataItem()
            begin
                if not DeleteOld then
                  CurrReport.Break;

                SetRange("Mailing Group Code",MailingGroupCode);
            end;
        }
        dataitem("Segment Header";"Segment Header")
        {
            DataItemTableView = sorting("No.");
            column(ReportForNavId_7133; 7133)
            {
            }
            dataitem("Segment Line";"Segment Line")
            {
                DataItemLink = "Segment No."=field("No.");
                DataItemTableView = sorting("Segment No.","Line No.");
                column(ReportForNavId_5030; 5030)
                {
                }
                dataitem("Mailing Group";"Mailing Group")
                {
                    DataItemTableView = sorting(Code);
                    RequestFilterFields = "Code";
                    column(ReportForNavId_1563; 1563)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        Clear("Contact Mailing Group");
                        "Contact Mailing Group"."Contact No." := "Segment Line"."Contact No.";
                        "Contact Mailing Group"."Mailing Group Code" := Code;
                        if "Contact Mailing Group".Insert then;
                    end;
                }
            }
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
                    field(DeleteOld;DeleteOld)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Delete Old Assignments';
                        ToolTip = 'Specifies if the previous contacts that were assigned to the mailing group are removed.';
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

    trigger OnPostReport()
    begin
        Message(
          Text001,
          "Mailing Group".TableCaption,MailingGroupCode,"Segment Header"."No.");
    end;

    trigger OnPreReport()
    begin
        MailingGroupCode := "Mailing Group".GetFilter(Code);
        if not "Mailing Group".Get(MailingGroupCode) then
          Error(Text000);
    end;

    var
        Text000: label 'Specify a Mailing Group Code.';
        Text001: label '%1 %2 is now applied to Segment %3.';
        DeleteOld: Boolean;
        MailingGroupCode: Code[10];
}

