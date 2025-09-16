#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1144 "Cost Register"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Cost Register.rdlc';
    Caption = 'Cost Register';

    dataset
    {
        dataitem("Cost Register";"Cost Register")
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(ReportForNavId_5327; 5327)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(CostRegisterTableFilter;TableCaption + ': ' + CostRegFilter)
            {
            }
            column(No_CostRegister;"No.")
            {
            }
            column(Amount_CostEntry;"Cost Entry".Amount)
            {
            }
            column(GLRegisterCaption;GLRegisterCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(FORMATPostingDateCaption;FORMATPostingDateCaptionLbl)
            {
            }
            column(CostTypeNameCaption;CostTypeNameCaptionLbl)
            {
            }
            column(GLRegisterNoCaption;GLRegisterNoCaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            dataitem("Cost Entry";"Cost Entry")
            {
                DataItemTableView = sorting("Entry No.");
                column(ReportForNavId_5276; 5276)
                {
                }
                column(PostingDate_CostEntry;Format("Posting Date"))
                {
                }
                column(DocNo_CostEntry;"Document No.")
                {
                    IncludeCaption = true;
                }
                column(Name_CostType;CostType.Name)
                {
                }
                column(Description_CostEntry;Description)
                {
                    IncludeCaption = true;
                }
                column(Amount1_CostEntry;Amount)
                {
                    IncludeCaption = true;
                }
                column(No_CostEntry;"Entry No.")
                {
                    IncludeCaption = true;
                }
                column(CostTypeNo_CostEntry;"Cost Type No.")
                {
                    IncludeCaption = true;
                }

                trigger OnAfterGetRecord()
                begin
                    if not CostType.Get("Cost Type No.") then
                      CostType.Init;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Entry No.","Cost Register"."From Cost Entry No.","Cost Register"."To Cost Entry No.");
                    CurrReport.CreateTotals(Amount);
                end;
            }

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals("Cost Entry".Amount);
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

    trigger OnPreReport()
    begin
        CostRegFilter := "Cost Register".GetFilters;
    end;

    var
        CostType: Record "Cost Type";
        CostRegFilter: Text;
        GLRegisterCaptionLbl: label 'Cost Register';
        CurrReportPageNoCaptionLbl: label 'Page';
        FORMATPostingDateCaptionLbl: label 'Posting Date';
        CostTypeNameCaptionLbl: label 'Name';
        GLRegisterNoCaptionLbl: label 'Register No.';
        TotalCaptionLbl: label 'Total';
}

