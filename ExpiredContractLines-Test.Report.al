#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5987 "Expired Contract Lines - Test"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Expired Contract Lines - Test.rdlc';
    Caption = 'Expired Contract Lines - Test';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Service Contract Line";"Service Contract Line")
        {
            DataItemTableView = sorting("Contract Type","Contract No.","Line No.") where("Contract Type"=const(Contract),"Contract Status"=const(Signed));
            RequestFilterFields = "Contract No.","Service Item No.";
            column(ReportForNavId_6062; 6062)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(DelToDate;Format(DelToDate))
            {
            }
            column(ReasonCode2_Code_________ReasonCode2_Description;ReasonCode2.Code + ' ' + ReasonCode2.Description)
            {
            }
            column(Service_Contract_Line__TABLECAPTION__________ServItemFilters;TableCaption + ': ' + ServItemFilters)
            {
            }
            column(ServItemFilters;ServItemFilters)
            {
            }
            column(DescriptionLine;DescriptionLine)
            {
            }
            column(Service_Contract_Line__Contract_No__;"Contract No.")
            {
            }
            column(Service_Contract_Line_Description;Description)
            {
            }
            column(Service_Contract_Line__Contract_Expiration_Date_;Format("Contract Expiration Date"))
            {
            }
            column(Service_Contract_Line__Service_Item_No__;"Service Item No.")
            {
            }
            column(Service_Contract_Line__Line_Amount_;"Line Amount")
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Expired_Contract_Lines___TestCaption;Expired_Contract_Lines___TestCaptionLbl)
            {
            }
            column(Delete_Contract_Lines_toCaption;Delete_Contract_Lines_toCaptionLbl)
            {
            }
            column(Reason_CodeCaption;Reason_CodeCaptionLbl)
            {
            }
            column(Service_Contract_Line__Contract_No__Caption;FieldCaption("Contract No."))
            {
            }
            column(Service_Contract_Line__Service_Item_No__Caption;FieldCaption("Service Item No."))
            {
            }
            column(Service_Contract_Line_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Service_Contract_Line__Contract_Expiration_Date_Caption;Service_Contract_Line__Contract_Expiration_Date_CaptionLbl)
            {
            }
            column(Service_Contract_Line__Line_Amount_Caption;FieldCaption("Line Amount"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                DescriptionLine := Text002;
            end;

            trigger OnPreDataItem()
            begin
                if DelToDate = 0D then
                  Error(Text000);
                ServMgtSetup.Get;
                if ServMgtSetup."Use Contract Cancel Reason" then
                  if ReasonCode = '' then
                    Error(Text001);
                if GetFilter("Contract No.") = '' then
                  SetFilter("Contract No.",'<>%1','');
                SetFilter("Contract Expiration Date",'<>%1&<=%2',0D,DelToDate);
            end;
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
                    field(DelToDate;DelToDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Remove Lines to';
                    }
                    field(ReasonCode;ReasonCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Reason Code';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            ReasonCode2.Reset;
                            ReasonCode2.Code := ReasonCode;
                            if Page.RunModal(0,ReasonCode2) = Action::LookupOK then begin
                              ReasonCode2.Get(ReasonCode2.Code);
                              ReasonCode := ReasonCode2.Code;
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            ReasonCode2.Get(ReasonCode);
                        end;
                    }
                    field("Reason Code";ReasonCode2.Description)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Reason Code Description';
                        Editable = false;
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
        if DelToDate = 0D then
          DelToDate := WorkDate;
        ServMgtSetup.Get;
    end;

    trigger OnPreReport()
    begin
        ServItemFilters := "Service Contract Line".GetFilters;
    end;

    var
        Text000: label 'You must fill in the Remove to field.';
        Text001: label 'You must fill in the Reason Code field.';
        Text002: label 'Would be removed';
        ServMgtSetup: Record "Service Mgt. Setup";
        ReasonCode2: Record "Reason Code";
        DescriptionLine: Text[60];
        DelToDate: Date;
        ReasonCode: Code[10];
        ServItemFilters: Text;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Expired_Contract_Lines___TestCaptionLbl: label 'Expired Contract Lines - Test';
        Delete_Contract_Lines_toCaptionLbl: label 'Delete Contract Lines to';
        Reason_CodeCaptionLbl: label 'Reason Code';
        Service_Contract_Line__Contract_Expiration_Date_CaptionLbl: label 'Contract Expiration Date';


    procedure InitVariables(LocalDelToDate: Date;LocalReasonCode: Code[10])
    begin
        DelToDate := LocalDelToDate;
        ReasonCode := LocalReasonCode;
        if ReasonCode <> '' then
          ReasonCode2.Get(ReasonCode);
    end;
}

