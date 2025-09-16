#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51224 "Procurement Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Procurement Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61154;UnknownTable61154)
        {
            DataItemTableView = where(Approval=const(Approve),Select=const(Yes));
            column(ReportForNavId_2561; 2561)
            {
            }
            column(CompanyLine5;CompanyLine5)
            {
            }
            column(CompanyLine4;CompanyLine4)
            {
            }
            column(CompanyLine3;CompanyLine3)
            {
            }
            column(CompanyLine2;CompanyLine2)
            {
            }
            column(CompanyLine1;CompanyLine1)
            {
            }
            column(Internal_Requisition_Plan_Line__Internal_Requisition_Plan_Line___Procurement_Type_;"PROC-Internal Req. Plan Line"."Procurement Type")
            {
            }
            column(Internal_Requisition_Plan_Line__Type_No__;"Type No.")
            {
            }
            column(Internal_Requisition_Plan_Line_Description;Description)
            {
            }
            column(Internal_Requisition_Plan_Line_Qty;Qty)
            {
            }
            column(Contacts__________________________________________________________________________________________Caption;Contacts__________________________________________________________________________________________CaptionLbl)
            {
            }
            column(Address__________________________________________________________________________________________Caption;Address__________________________________________________________________________________________CaptionLbl)
            {
            }
            column(Town__________________________________________________________________________________________Caption;Town__________________________________________________________________________________________CaptionLbl)
            {
            }
            column(Name__________________________________________________________________________________________Caption;Name__________________________________________________________________________________________CaptionLbl)
            {
            }
            column(Procurement_TypeCaption;Procurement_TypeCaptionLbl)
            {
            }
            column(Procurement_TenderCaption;Procurement_TenderCaptionLbl)
            {
            }
            column(Supplier_DetailsCaption;Supplier_DetailsCaptionLbl)
            {
            }
            column(Delivery_Schedule__________________________________________________________________________________________Caption;Delivery_Schedule__________________________________________________________________________________________CaptionLbl)
            {
            }
            column(Terms_Of_Payment__________________________________________________________________________________________Caption;Terms_Of_Payment__________________________________________________________________________________________CaptionLbl)
            {
            }
            column(Internal_Requisition_Plan_Line__Type_No__Caption;FieldCaption("Type No."))
            {
            }
            column(Internal_Requisition_Plan_Line_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Internal_Requisition_Plan_Line_QtyCaption;FieldCaption(Qty))
            {
            }
            column(Unit_CostCaption;Unit_CostCaptionLbl)
            {
            }
            column(Total_CostCaption;Total_CostCaptionLbl)
            {
            }
            column(Product_BrandCaption;Product_BrandCaptionLbl)
            {
            }
            column(Delivery_DaysCaption;Delivery_DaysCaptionLbl)
            {
            }
            column(Country_Of_OriginCaption;Country_Of_OriginCaptionLbl)
            {
            }
            column(RemarksCaption;RemarksCaptionLbl)
            {
            }
            column(Internal_Requisition_Plan_Line_No_;"No.")
            {
            }
            column(Internal_Requisition_Plan_Line_Line_No_;"Line No.")
            {
            }

            trigger OnPreDataItem()
            begin
                       if "Procurement Type."=0 then
                       begin
                         Error('Select The Procurement Type.');
                       end;
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
        //retrieve the company information
        GetCompanyInformation();
    end;

    var
        Budget_Bal: Decimal;
        CheckReport: Report Check;
        NumberText: array [2] of Text[80];
        PostingDate: Date;
        "PurchaseHeaderNo.": Code[20];
        PurchaseHeader: Record "Purch. Inv. Header";
        Company: Record "Company Information";
        CompanyLine1: Text[100];
        CompanyLine2: Text[100];
        CompanyLine3: Text[100];
        CompanyLine4: Text[100];
        CompanyLine5: Text[100];
        Vendor: Record Vendor;
        VendorName: Text[150];
        VendorAddress: Text[100];
        VendorAddress2: Text[100];
        VendorPhoneFax: Text[100];
        VendorEmail: Text[100];
        Genjournal: Record "Gen. Journal Line";
        CHEQNO: Code[10];
        Amount: Decimal;
        WTAX: Decimal;
        ate: Text[100];
        PurchLine: Record "Purch. Inv. Line";
        "G/l Account": Code[10];
        Description: Integer;
        Pdate: Date;
        DocumentNo: Code[20];
        Detail: Text[50];
        BankName: Text[30];
        TAmount: Decimal;
        Hesabu: Integer;
        BankAcc: Code[20];
        BankAccc: Record "Bank Account";
        BankCurr: Code[10];
        Gensetup: Record "General Ledger Setup";
        Payments: Record UnknownRecord61134;
        "Procurement Type.": Option " ","Open Tender","Restricted Tender","Request For Proposal","Direct Procurement","Request For Quotations","Low Value Procurement","International Tender",Other;
        CurrRate: Code[10];
        Contacts__________________________________________________________________________________________CaptionLbl: label 'Contacts..........................................................................................';
        Address__________________________________________________________________________________________CaptionLbl: label 'Address..........................................................................................';
        Town__________________________________________________________________________________________CaptionLbl: label 'Town..........................................................................................';
        Name__________________________________________________________________________________________CaptionLbl: label 'Name..........................................................................................';
        Procurement_TypeCaptionLbl: label 'Procurement Type';
        Procurement_TenderCaptionLbl: label 'Procurement Tender';
        Supplier_DetailsCaptionLbl: label 'Supplier Details';
        Delivery_Schedule__________________________________________________________________________________________CaptionLbl: label 'Delivery Schedule..........................................................................................';
        Terms_Of_Payment__________________________________________________________________________________________CaptionLbl: label 'Terms Of Payment..........................................................................................';
        Unit_CostCaptionLbl: label 'Unit Cost';
        Total_CostCaptionLbl: label 'Total Cost';
        Product_BrandCaptionLbl: label 'Product Brand';
        Delivery_DaysCaptionLbl: label 'Delivery Days';
        Country_Of_OriginCaptionLbl: label 'Country Of Origin';
        RemarksCaptionLbl: label 'Remarks';


    procedure GetCompanyInformation()
    begin
        Company.Reset;
        if Company.Find('-') then
            begin
                CompanyLine1:=Company.Name;
                CompanyLine2:=Company.Address +  ' ' + Company."Address 2" + '-' + Company."Post Code" +  Company.City + ',KENYA' ;
                CompanyLine3:='Tel No.:' + ' ' + Company."Phone No." + ' Fax No.:' + Company."Fax No.";
                CompanyLine4:='E-mail:' + ' ' + Company."E-Mail";
                CompanyLine5:='www.karu.ac.ke';
            end;
    end;


    procedure GetLPONumber(var InvoiceNo: Code[20])
    begin
        //reset the purchase header record and retrieve the l.p.o number from the database using the GET method
        PurchaseHeader.Reset;
        //use the parameter passed by the client and retrieve the details from the database
        if PurchaseHeader.Get(InvoiceNo) then
            begin
                //set the purchase order number from the database to the variable holding the same
                "PurchaseHeaderNo.":=PurchaseHeader."Order No.";
                PostingDate:=PurchaseHeader."Posting Date";
            end;
    end;
}

