#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51292 "Revenue Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Revenue Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61157;UnknownTable61157)
        {
            DataItemTableView = sorting("Doc No") where(Posted=const(Yes));
            RequestFilterFields = "Doc No",Date,"Receiving Bank A/C","Campus Code","Customer No","Received By";
            column(ReportForNavId_3303; 3303)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(TotalAmt;TotalAmt)
            {
            }
            column(TotalAmt_Control1102760007;TotalAmt)
            {
            }
            column(Revenue_ReportCaption;Revenue_ReportCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Cash_Sale_Line__Total_Amount_Caption;"FIN-Cash Sale Line".FieldCaption("Total Amount"))
            {
            }
            column(Cash_Sale_Line__Unit_Price_Caption;"FIN-Cash Sale Line".FieldCaption("Unit Price"))
            {
            }
            column(Cash_Sale_Line_QuantityCaption;"FIN-Cash Sale Line".FieldCaption(Quantity))
            {
            }
            column(Cash_Sale_Line_DescriptionCaption;"FIN-Cash Sale Line".FieldCaption(Description))
            {
            }
            column(Cash_Sale_Line_CodeCaption;"FIN-Cash Sale Line".FieldCaption(Code))
            {
            }
            column(Recieved_ByCaption;Recieved_ByCaptionLbl)
            {
            }
            column(Doc_NoCaption;Doc_NoCaptionLbl)
            {
            }
            column(DateCaption;DateCaptionLbl)
            {
            }
            column(Customer_NameCaption;Customer_NameCaptionLbl)
            {
            }
            column(Continued_TotalCaption;Continued_TotalCaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            column(Cash_Sale_Header_Doc_No;"Doc No")
            {
            }
            dataitem(UnknownTable61158;UnknownTable61158)
            {
                DataItemLink = No=field("Doc No");
                RequestFilterFields = "Code";
                column(ReportForNavId_7967; 7967)
                {
                }
                column(Cash_Sale_Line_Code;Code)
                {
                }
                column(Cash_Sale_Line_Description;Description)
                {
                }
                column(Cash_Sale_Line_Quantity;Quantity)
                {
                }
                column(Cash_Sale_Line__Unit_Price_;"Unit Price")
                {
                }
                column(Cash_Sale_Line__Total_Amount_;"Total Amount")
                {
                }
                column(Cash_Sale_Header___Received_By_;"FIN-Cash Sale Header"."Received By")
                {
                }
                column(DocNo;DocNo)
                {
                }
                column(mDate;mDate)
                {
                }
                column(PF;PF)
                {
                }
                column(Cash_Sale_Line_Line_No;"Line No")
                {
                }
                column(Cash_Sale_Line_No;No)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                   mDate:="FIN-Cash Sale Header".Date;
                   Receipt:="FIN-Cash Sale Header"."Receipt No";
                   DocNo:="FIN-Cash Sale Header"."Doc No";
                   PF:="FIN-Cash Sale Header"."Customer Name";
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
        TotalAmt: Decimal;
        Receipt: Code[20];
        DocNo: Code[20];
        mDate: Date;
        PF: Text[100];
        Revenue_ReportCaptionLbl: label 'Revenue Report';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Recieved_ByCaptionLbl: label 'Recieved By';
        Doc_NoCaptionLbl: label 'Doc No';
        DateCaptionLbl: label 'Date';
        Customer_NameCaptionLbl: label 'Customer Name';
        Continued_TotalCaptionLbl: label 'Continued Total';
        TotalCaptionLbl: label 'Total';
}

