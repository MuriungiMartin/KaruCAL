#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 65580 "Direct Sales Register/User"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Direct Sales RegisterUser.rdlc';

    dataset
    {
        dataitem(SalesHeader;"Sales Shipment Header")
        {
            DataItemTableView = where("Cash Sale Order"=filter(true),"User ID"=filter(<>'WANJALA'));
            PrintOnlyIfDetail = false;
            RequestFilterFields = "Sell-to Customer No.","Posting Date","No.","User ID";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(OderDate;SalesHeader."Posting Date")
            {
            }
            column(seq;seq)
            {
            }
            column(StartDate;StartDate)
            {
            }
            column(EndDate;EndDate)
            {
            }
            column(MonthName;MonthName)
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
            column(SalesPersonCode;SalesHeader."Salesperson Code")
            {
            }
            column(InvAmount;SalesHeader."Document Amount")
            {
            }
            column(Users;SalesHeader."User ID")
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
            column(filters;SalesHeader.GetFilters)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(MonthName);
                Clear(IntMonth);
                seq:=seq+1;
                /*IntMonth:=DATE2DMY(SalesHeader."Posting Date",2);
                IF IntMonth<>0 THEN BEGIN
                  IF IntMonth=1 THEN BEGIN
                    MonthName:='JAN';
                    END ELSE IF IntMonth=2 THEN BEGIN
                      MonthName:='FEB';
                      END  ELSE IF IntMonth=3 THEN BEGIN
                        MonthName:='MAR';
                      END  ELSE IF IntMonth=4 THEN BEGIN
                        MonthName:='APRIL';
                      END  ELSE IF IntMonth=5 THEN BEGIN
                        MonthName:='MAY';
                      END  ELSE IF IntMonth=6 THEN BEGIN
                        MonthName:='JUNE';
                      END  ELSE IF IntMonth=7 THEN BEGIN
                        MonthName:='JULY';
                      END  ELSE IF IntMonth=8 THEN BEGIN
                        MonthName:='AUG';
                      END  ELSE IF IntMonth=9 THEN BEGIN
                        MonthName:='SEPT';
                      END  ELSE IF IntMonth=10 THEN BEGIN
                        MonthName:='OCT';
                      END  ELSE IF IntMonth=11 THEN BEGIN
                        MonthName:='NOV';
                      END  ELSE IF IntMonth=12 THEN BEGIN
                        MonthName:='DEC';
                      END
                  END;*/

            end;

            trigger OnPreDataItem()
            begin
                SalesHeader.SetRange("Posting Date",StartDate,EndDate);
                SalesHeader.SetCurrentkey("Posting Date");
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
                    Caption = 'Date Range';
                    field(StartDate;StartDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Start Date:';
                    }
                    field(EndDate;EndDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'End Date:';
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

        Clear(seq);
    end;

    trigger OnPreReport()
    begin
        if ((StartDate=0D) or (EndDate=0D)) then Error('Specify date range');
    end;

    var
        info: Record "Company Information";
        route: Code[20];
        cust: Record Customer;
        MonthName: Code[20];
        IntMonth: Integer;
        StartDate: Date;
        EndDate: Date;
        seq: Integer;
}

