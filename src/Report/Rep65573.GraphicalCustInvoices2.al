#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 65573 "Graphical Cust. Invoices 2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Graphical Cust. Invoices 2.rdlc';

    dataset
    {
        dataitem(SalesHeader;"Sales Invoice Header")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Sell-to Customer No.","Posting Date","No.";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(StartDate;StartDate)
            {
            }
            column(EndDate;EndDate)
            {
            }
            column(OderDate;SalesHeader."Order Date")
            {
            }
            column(docNo;SalesHeader."No.")
            {
            }
            column(CustNo;SalesHeader."Sell-to Customer No.")
            {
            }
            column(CustName;SalesHeader."Bill-to Name")
            {
            }
            column(SalesPerson;SalesHeader."Salesperson Code")
            {
            }
            column(PostingDate;SalesHeader."Posting Date")
            {
            }
            column(PostingDesc;SalesHeader."Posting Description")
            {
            }
            column(CompAddress;info.Address)
            {
            }
            column(CompAddress1;info."Address 2")
            {
            }
            column(CompPhonenO;info."Phone No.")
            {
            }
            column(CompPhoneNo2;info."Phone No. 2")
            {
            }
            column(CompPic;info.Picture)
            {
            }
            column(CompEmail1;info."E-Mail")
            {
            }
            column(CompHome;info."Home Page")
            {
            }
            dataitem(SalesLines;"Sales Invoice Line")
            {
                DataItemLink = "Document No."=field("No.");
                DataItemTableView = where(Quantity=filter(>0),"No."=filter(<>''));
                PrintOnlyIfDetail = false;
                column(ReportForNavId_1000000001; 1000000001)
                {
                }
                column(SalesLineNo;SalesLines."Line No."/100)
                {
                }
                column(SalesDocNo;SalesLines."Document No.")
                {
                }
                column(SalesItemNo;SalesLines."No.")
                {
                }
                column(SelesItemDesc;SalesLines.Description)
                {
                }
                column(LineAmountIncludingVAT;SalesLines."Amount Including VAT")
                {
                }
                column(LineAmount;SalesLines.Amount)
                {
                }
                column(SalesQuantity;SalesLines.Quantity)
                {
                }
                column(SalesUnitOfMeasure;SalesLines."Unit of Measure")
                {
                }
                column(SalesUnitPrice;SalesLines."Unit Price")
                {
                }
                column(SalesLineAmount;SalesLines."Unit Price"*SalesLines.Quantity)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //IF SalesLines."Line No.">99 THEN SalesLines."Line No.":=SalesLines."Line No."/100;
                end;
            }

            trigger OnPreDataItem()
            begin
                SalesHeader.SetRange("Posting Date",StartDate,EndDate);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(DateFilters)
                {
                    Caption = 'Date Filter';
                    field(strsDate;StartDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Start Date';
                    }
                    field(endDate;EndDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'End Date';
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
        if info.Get() then begin
         // info.CALCFIELDS(Picture);
          end;
    end;

    trigger OnPreReport()
    begin
        if ((StartDate=0D) or (EndDate=0D)) then Error('Specify begining and end date');
        if StartDate>EndDate then Error('Invalid start date!');
    end;

    var
        info: Record "Company Information";
        route: Code[20];
        cust: Record Customer;
        StartDate: Date;
        EndDate: Date;
}

