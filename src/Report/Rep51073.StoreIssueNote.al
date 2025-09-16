#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51073 "Store Issue Note"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Store Issue Note.rdlc';

    dataset
    {
        dataitem(UnknownTable61148;UnknownTable61148)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(ReportForNavId_5506; 5506)
            {
            }
            column(Store_Issue__No__;"No.")
            {
            }
            column(Store_Issue_Date;Date)
            {
            }
            column(Store_Issue__Date_Issued_;"Date Issued")
            {
            }
            column(Store_Issue__Received_By_;"Received By")
            {
            }
            column(Store_Issue__Issued_By_;"Issued By")
            {
            }
            column(Store_Issue_Status;Status)
            {
            }
            column(Store_Issue_Remarks;Remarks)
            {
            }
            column(Pageno_________FORMAT_CurrReport_PAGENO_;Pageno + ' ' + Format(CurrReport.PageNo))
            {
            }
            column(ISSUE_NOTECaption;ISSUE_NOTECaptionLbl)
            {
            }
            column(Requisition_No_Caption;Requisition_No_CaptionLbl)
            {
            }
            column(Item_No_Caption;Item_No_CaptionLbl)
            {
            }
            column(DescriptionCaption;DescriptionCaptionLbl)
            {
            }
            column(QtyCaption;QtyCaptionLbl)
            {
            }
            column(U_O_MCaption;U_O_MCaptionLbl)
            {
            }
            column(Units_U_O_MCaption;Units_U_O_MCaptionLbl)
            {
            }
            column(Unit_CostCaption;Unit_CostCaptionLbl)
            {
            }
            column(Total_CostCaption;Total_CostCaptionLbl)
            {
            }
            column(Received_by_Caption;Received_by_CaptionLbl)
            {
            }
            column(Issued_by_Caption;Issued_by_CaptionLbl)
            {
            }
            column(Voucher_No_Caption;Voucher_No_CaptionLbl)
            {
            }
            column(Date_Caption;Date_CaptionLbl)
            {
            }
            column(Date_IssuedCaption;Date_IssuedCaptionLbl)
            {
            }
            column(StatusCaption;StatusCaptionLbl)
            {
            }
            column(General_Issue_RemarksCaption;General_Issue_RemarksCaptionLbl)
            {
            }
            column(DataItem1000000061;Received_by__________________________________________________________________________________________________________________Lbl)
            {
            }
            column(DataItem1000000062;Issued_by____________________________________________________________________________________________________________________Lbl)
            {
            }
            column(Date________________________________________________________________Caption;Date________________________________________________________________CaptionLbl)
            {
            }
            column(Date________________________________________________________________Caption_Control1000000064;Date________________________________________________________________Caption_Control1000000064Lbl)
            {
            }
            column(DataItem1000000065;Signature____________________________________________________________________________________________________________________Lbl)
            {
            }
            column(DataItem1000000066;Signature_________________________________________________________________________________________________________________000Lbl)
            {
            }
            dataitem(UnknownTable61149;UnknownTable61149)
            {
                DataItemLink = "No."=field("No.");
                column(ReportForNavId_7464; 7464)
                {
                }
                column(Store_Issue_Line__Requisition_No__;"Requisition No.")
                {
                }
                column(Store_Issue_Line__Type_No__;"Type No.")
                {
                }
                column(Store_Issue_Line_Description;Description)
                {
                }
                column(Store_Issue_Line_Qty;Qty)
                {
                }
                column(Store_Issue_Line__Unit_of_Measure_;"Unit of Measure")
                {
                }
                column(Store_Issue_Line__Units_per_Unit_of_Measure_;"Units per Unit of Measure")
                {
                }
                column(Store_Issue_Line__Unit_Direct_Cost_;"Unit Direct Cost")
                {
                }
                column(Store_Issue_Line__Total_Cost_;"Total Cost")
                {
                }
                column(Store_Issue_Line_No_;"No.")
                {
                }
                column(Store_Issue_Line_Type;Type)
                {
                }
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("No.");
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

    trigger OnInitReport()
    begin
        getCompanyInformation();
    end;

    var
        Pageno: label 'Pageno';
        Company: Record "Company Information";
        CompanyLine1: Text[100];
        CompanyLine2: Text[100];
        CompanyLine3: Text[100];
        CompanyLine4: Text[100];
        CompanyLine5: Text[100];
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        ISSUE_NOTECaptionLbl: label 'ISSUE NOTE';
        Requisition_No_CaptionLbl: label 'Requisition No.';
        Item_No_CaptionLbl: label 'Item No.';
        DescriptionCaptionLbl: label 'Description';
        QtyCaptionLbl: label 'Qty';
        U_O_MCaptionLbl: label 'U.O.M';
        Units_U_O_MCaptionLbl: label 'Units/U.O.M';
        Unit_CostCaptionLbl: label 'Unit Cost';
        Total_CostCaptionLbl: label 'Total Cost';
        Received_by_CaptionLbl: label 'Received by.';
        Issued_by_CaptionLbl: label 'Issued by.';
        Voucher_No_CaptionLbl: label 'Voucher No.';
        Date_CaptionLbl: label 'Date.';
        Date_IssuedCaptionLbl: label 'Date Issued';
        StatusCaptionLbl: label 'Status';
        General_Issue_RemarksCaptionLbl: label 'General Issue Remarks';
        Received_by__________________________________________________________________________________________________________________Lbl: label 'Received by................................................................................................................................';
        Issued_by____________________________________________________________________________________________________________________Lbl: label 'Issued by................................................................................................................................';
        Date________________________________________________________________CaptionLbl: label 'Date................................................................';
        Date________________________________________________________________Caption_Control1000000064Lbl: label 'Date................................................................';
        Signature____________________________________________________________________________________________________________________Lbl: label 'Signature................................................................................................................................';
        Signature_________________________________________________________________________________________________________________000Lbl: label 'Signature................................................................................................................................';


    procedure getCompanyInformation()
    begin
        Company.Reset;
        if Company.Find('-') then
            begin
                CompanyLine1:=Company.Name;
                CompanyLine2:=Company.Address + ' ' + Company."Address 2" + '-' + Company."Post Code" + ' ' + Company.City + ',KENYA';
                CompanyLine3:='Tel No.: ' + Company."Phone No." + ', Fax No.: ' + Company."Fax No.";
                CompanyLine4:='E-mail.:' + Company."E-Mail";
                CompanyLine5:='www.karu.ac.ke';
            end;
    end;
}

