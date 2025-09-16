#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 99917 "FINCafe Receipts Correction Li"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/FINCafe Receipts Correction Li.rdlc';

    dataset
    {
        dataitem(BankAccounts;"Bank Account")
        {
            DataItemTableView = sorting("No.") order(ascending) where("No."=filter(<>''));
            PrintOnlyIfDetail = true;
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(Names;CompanyInformation.Name)
            {
            }
            column(Pics;CompanyInformation.Picture)
            {
            }
            column(Addresses;CompanyInformation.Address+' '+CompanyInformation."Address 2")
            {
            }
            column(mails;CompanyInformation."E-Mail"+' '+CompanyInformation."Home Page")
            {
            }
            column(phone;CompanyInformation."Phone No.")
            {
            }
            column(BankNo;BankAccounts."No.")
            {
            }
            column(BankName;BankAccounts.Name)
            {
            }
            dataitem(BankAccLedger;"Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No."=field("No.");
                RequestFilterFields = "Bank Account No.","Posting Date","Document Type","User ID","Global Dimension 1 Code","Global Dimension 2 Code";
                column(ReportForNavId_1000000001; 1000000001)
                {
                }
                column(EntryNo;BankAccLedger."Entry No.")
                {
                }
                column(PostingDateFilter;BankAccLedger.GetFilters)
                {
                }
                column(DocumentNo;BankAccLedger."Document No.")
                {
                }
                column(Descriptions;BankAccLedger.Description)
                {
                }
                column(DocType;BankAccLedger."Document Type")
                {
                }
                column(UsersID;BankAccLedger."User ID")
                {
                }
                column(DebitAmount;BankAccLedger."Debit Amount")
                {
                }
                column(CreditAmount;BankAccLedger."Credit Amount")
                {
                }
                column(DocDate;BankAccLedger."Document Date")
                {
                }
                column(ExternalDocNo;BankAccLedger."External Document No.")
                {
                }
                column(Dim1;BankAccLedger."Global Dimension 1 Code")
                {
                }
                column(Dim2;BankAccLedger."Global Dimension 2 Code")
                {
                }
                column(AccPostingGroup;BankAccLedger."Bank Acc. Posting Group")
                {
                }
                column(Amounts;BankAccLedger.Amount)
                {
                }
                column(extNo;BankAccLedger."External Document No.")
                {
                }
                column(SalesOrderNo;BankAccLedger."Sales Order No")
                {
                }
                column(SalesShipmentNo;BankAccLedger."Sales Shipment No")
                {
                }
                column(SalesAmount;BankAccLedger."Sales Amount")
                {
                }
                column(PostedVariance;BankAccLedger.Amount-BankAccLedger."Sales Amount")
                {
                }
                column(Occurances;BankAccLedger.Occurances)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //BankAccLedger."User ID" := STRSUBSTNO(BankAccLedger."User ID",'KUCSERVER\','');
                    BankAccLedger.CalcFields("Sales Amount","Sales Order No","Sales Shipment No",Occurances);
                    if TransactionsTypes = Transactionstypes::Receipts then
                      if BankAccLedger.Amount<0 then CurrReport.Skip
                      else if TransactionsTypes = Transactionstypes::Payments then
                      if BankAccLedger.Amount>0 then CurrReport.Skip;
                end;
            }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field(TransTypes;TransactionsTypes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transaction Type';
                    OptionCaption = ' ,Receipts,Payments,Both';
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
        CompanyInformation.Reset;
        if CompanyInformation.Find('-') then
          CompanyInformation.CalcFields(Picture);
    end;

    trigger OnPreReport()
    begin
        if TransactionsTypes = Transactionstypes::" " then Error('Specify the transaction type');
        Clear(UserSetup);
        UserSetup.Reset;
        UserSetup.SetRange("User ID",UserId);
        if UserSetup.Find('-') then
          UserSetup.TestField("Can View Sales Reports")
        else Error('Access denied!');
    end;

    var
        TransactionsTypes: Option " ",Receipts,Payments,Both;
        CompanyInformation: Record "Company Information";
        UserSetup: Record "User Setup";
}

