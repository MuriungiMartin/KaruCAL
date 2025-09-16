#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5196 "Remove Contacts - Refine"
{
    Caption = 'Remove Contacts - Refine';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Segment Header";"Segment Header")
        {
            DataItemTableView = sorting("No.");
            column(ReportForNavId_7133; 7133)
            {
            }

            trigger OnPreDataItem()
            begin
                CurrReport.Break;
            end;
        }
        dataitem(Contact;Contact)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Search Name",Type,"Salesperson Code","Post Code","Country/Region Code","Territory Code";
            column(ReportForNavId_6698; 6698)
            {
            }

            trigger OnPreDataItem()
            begin
                CurrReport.Break;
            end;
        }
        dataitem("Contact Profile Answer";"Contact Profile Answer")
        {
            DataItemTableView = sorting("Contact No.","Profile Questionnaire Code","Line No.");
            RequestFilterFields = "Profile Questionnaire Code","Line No.";
            RequestFilterHeading = 'Profile';
            column(ReportForNavId_3762; 3762)
            {
            }

            trigger OnPreDataItem()
            begin
                CurrReport.Break;
            end;
        }
        dataitem("Contact Mailing Group";"Contact Mailing Group")
        {
            DataItemTableView = sorting("Contact No.","Mailing Group Code");
            RequestFilterFields = "Mailing Group Code";
            column(ReportForNavId_6043; 6043)
            {
            }

            trigger OnPreDataItem()
            begin
                CurrReport.Break;
            end;
        }
        dataitem("Interaction Log Entry";"Interaction Log Entry")
        {
            DataItemTableView = sorting("Entry No.");
            RequestFilterFields = Date,"Segment No.","Campaign No.",Evaluation,"Interaction Template Code","Salesperson Code";
            column(ReportForNavId_3056; 3056)
            {
            }

            trigger OnPreDataItem()
            begin
                CurrReport.Break;
            end;
        }
        dataitem("Contact Job Responsibility";"Contact Job Responsibility")
        {
            DataItemTableView = sorting("Contact No.","Job Responsibility Code");
            RequestFilterFields = "Job Responsibility Code";
            column(ReportForNavId_6030; 6030)
            {
            }

            trigger OnPreDataItem()
            begin
                CurrReport.Break;
            end;
        }
        dataitem("Contact Industry Group";"Contact Industry Group")
        {
            DataItemTableView = sorting("Contact No.","Industry Group Code");
            RequestFilterFields = "Industry Group Code";
            column(ReportForNavId_4008; 4008)
            {
            }

            trigger OnPreDataItem()
            begin
                CurrReport.Break;
            end;
        }
        dataitem("Contact Business Relation";"Contact Business Relation")
        {
            DataItemTableView = sorting("Contact No.","Business Relation Code");
            RequestFilterFields = "Business Relation Code";
            column(ReportForNavId_8768; 8768)
            {
            }

            trigger OnPreDataItem()
            begin
                CurrReport.Break;
            end;
        }
        dataitem("Value Entry";"Value Entry")
        {
            DataItemTableView = sorting("Source Type","Source No.","Item No.","Posting Date");
            RequestFilterFields = "Item No.","Variant Code","Posting Date","Inventory Posting Group";
            column(ReportForNavId_8894; 8894)
            {
            }

            trigger OnPreDataItem()
            begin
                CurrReport.Break;
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
                    field(EntireCompanies;EntireCompanies)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Entire Companies';
                        ToolTip = 'Specifies if you want to remove all the person contacts employed in the company that you remove from the segment.';
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

    trigger OnPreReport()
    begin
        Clear(ReduceRefineSegment);
        ReduceRefineSegment.SetTableview("Segment Header");
        ReduceRefineSegment.SetTableview(Contact);
        ReduceRefineSegment.SetTableview("Contact Profile Answer");
        ReduceRefineSegment.SetTableview("Contact Mailing Group");
        ReduceRefineSegment.SetTableview("Interaction Log Entry");
        ReduceRefineSegment.SetTableview("Contact Job Responsibility");
        ReduceRefineSegment.SetTableview("Contact Industry Group");
        ReduceRefineSegment.SetTableview("Contact Business Relation");
        ReduceRefineSegment.SetTableview("Value Entry");
        ReduceRefineSegment.SetOptions(Report::"Remove Contacts - Refine",EntireCompanies);
        ReduceRefineSegment.RunModal;
    end;

    var
        ReduceRefineSegment: Report "Remove Contacts";
        EntireCompanies: Boolean;
}

