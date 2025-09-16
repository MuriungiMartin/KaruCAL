#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5063 "Segment - Contacts"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Segment - Contacts.rdlc';
    Caption = 'Segment - Contacts';

    dataset
    {
        dataitem("Segment Header";"Segment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Campaign No.","Salesperson Code";
            column(ReportForNavId_7133; 7133)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(SegmentHeaderCaption;TableCaption + ': ' + SegmentFilter)
            {
            }
            column(SegmentFilter;SegmentFilter)
            {
            }
            column(ContactCaption;Contact.TableCaption + ': ' + ContFilter)
            {
            }
            column(ContFilter;ContFilter)
            {
            }
            column(No_SegmentHeader;"No.")
            {
            }
            column(Description_SegHeader;Description)
            {
            }
            column(GroupNo;GroupNo)
            {
            }
            column(SegmentContactsCaption;SegmentContactsCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            dataitem("Segment Line";"Segment Line")
            {
                DataItemLink = "Segment No."=field("No.");
                DataItemTableView = sorting("Contact No.","Segment No.");
                column(ReportForNavId_5030; 5030)
                {
                }
                dataitem(Contact;Contact)
                {
                    DataItemLink = "No."=field("Contact No.");
                    DataItemTableView = sorting("No.");
                    RequestFilterFields = "No.","Search Name",Type;
                    column(ReportForNavId_6698; 6698)
                    {
                    }
                    column(ContAddr7;ContAddr[7])
                    {
                    }
                    column(ContAddr6;ContAddr[6])
                    {
                    }
                    column(ContAddr5;ContAddr[5])
                    {
                    }
                    column(ContAddr4;ContAddr[4])
                    {
                    }
                    column(ContAddr3;ContAddr[3])
                    {
                    }
                    column(ContAddr2;ContAddr[2])
                    {
                    }
                    column(ContAddr1;ContAddr[1])
                    {
                    }
                    column(No_Contact;"No.")
                    {
                        IncludeCaption = true;
                    }
                    column(CurrencyCode_Cont;"Currency Code")
                    {
                        IncludeCaption = true;
                    }
                    column(SalespersonCode_Cont;"Salesperson Code")
                    {
                        IncludeCaption = true;
                    }
                    column(NoofInteractions_Cont;"No. of Interactions")
                    {
                        IncludeCaption = true;
                    }
                    column(CostLCY_Cont;"Cost (LCY)")
                    {
                        IncludeCaption = true;
                    }
                    column(NoofOpportunities_Cont;"No. of Opportunities")
                    {
                        IncludeCaption = true;
                    }
                    column(EstimatedValueLCY_Cont;"Estimated Value (LCY)")
                    {
                        IncludeCaption = true;
                    }
                    column(ContAddr8;ContAddr[8])
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        FormatAddr.ContactAddr(ContAddr,Contact);
                        if Counter = RecPerPageNum then begin
                          GroupNo := GroupNo + 1;
                          Counter := 0;
                        end;
                        Counter := Counter + 1;
                    end;
                }
            }
        }
    }

    requestpage
    {
        SaveValues = true;

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

    trigger OnPreReport()
    begin
        ContFilter := Contact.GetFilters;
        SegmentFilter := "Segment Header".GetFilters;

        Counter := 0;
        GroupNo := 1;
        RecPerPageNum := 4;
    end;

    var
        FormatAddr: Codeunit "Format Address";
        ContFilter: Text;
        SegmentFilter: Text;
        ContAddr: array [8] of Text[50];
        GroupNo: Integer;
        Counter: Integer;
        RecPerPageNum: Integer;
        SegmentContactsCaptionLbl: label 'Segment - Contacts';
        CurrReportPageNoCaptionLbl: label 'Page';
}

