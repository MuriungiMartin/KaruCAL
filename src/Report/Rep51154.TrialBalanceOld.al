#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51154 "Trial Balance Old"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Trial Balance Old.rdlc';
    Caption = 'Trial Balance';

    dataset
    {
        dataitem("G/L Account";"G/L Account")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Account Type","Date Filter","Global Dimension 1 Filter","Global Dimension 2 Filter","Global Dimension 3 Filter";
            column(ReportForNavId_6710; 6710)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(STRSUBSTNO_Text000_PeriodText_;StrSubstNo(Text000,PeriodText))
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(G_L_Account__TABLECAPTION__________GLFilter;"G/L Account".TableCaption + ': ' + GLFilter)
            {
            }
            column(EmptyString;'')
            {
            }
            column(Totaldebit;Totaldebit)
            {
            }
            column(Totalcredit;-Totalcredit)
            {
            }
            column(Trial_BalanceCaption;Trial_BalanceCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(EMAIL_admin_cuc_ac_keCaption;EMAIL_admin_cuc_ac_keCaptionLbl)
            {
            }
            column(FAX_0202310302Caption;FAX_0202310302CaptionLbl)
            {
            }
            column(TEL_254_020_2310512Caption;TEL_254_020_2310512CaptionLbl)
            {
            }
            column(P_O_BOX_109_60400__kilimamboCaption;P_O_BOX_109_60400__kilimamboCaptionLbl)
            {
            }
            column(No_Caption;No_CaptionLbl)
            {
            }
            column(PADSTR_____G_L_Account__Indentation___3___G_L_Account__NameCaption;PADSTR_____G_L_Account__Indentation___3___G_L_Account__NameCaptionLbl)
            {
            }
            column(G_L_Account___Net_Change_Caption;G_L_Account___Net_Change_CaptionLbl)
            {
            }
            column(G_L_Account___Net_Change__Control22Caption;G_L_Account___Net_Change__Control22CaptionLbl)
            {
            }
            column(TotalsCaption;TotalsCaptionLbl)
            {
            }
            column(G_L_Account_No_;"No.")
            {
            }
            dataitem(BlankLineCounter;"Integer")
            {
                DataItemTableView = sorting(Number);
                column(ReportForNavId_8412; 8412)
                {
                }

                trigger OnPreDataItem()
                begin
                    SetRange(Number,1,"G/L Account"."No. of Blank Lines");
                end;
            }
            dataitem("Integer";"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_5444; 5444)
                {
                }
                column(G_L_Account___No__;"G/L Account"."No.")
                {
                }
                column(PADSTR_____G_L_Account__Indentation___3___G_L_Account__Name;PadStr('',"G/L Account".Indentation * 3)+"G/L Account".Name)
                {
                }
                column(G_L_Account___Net_Change_;"G/L Account"."Net Change")
                {
                }
                column(G_L_Account___Net_Change__Control22;-"G/L Account"."Net Change")
                {
                    AutoFormatType = 1;
                }
                column(G_L_Account___No___Control25;"G/L Account"."No.")
                {
                }
                column(PADSTR_____G_L_Account__Indentation___3___G_L_Account__Name_Control26;PadStr('',"G/L Account".Indentation * 3)+"G/L Account".Name)
                {
                }
                column(G_L_Account___Net_Change__Control27;"G/L Account"."Net Change")
                {
                }
                column(G_L_Account___Net_Change__Control28;-"G/L Account"."Net Change")
                {
                    AutoFormatType = 1;
                }
                column(Integer_Number;Number)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Net Change","Balance at Date");
                if PrintToExcel then
                  MakeExcelDataBody;

                if ChangeGroupNo then begin
                  PageGroupNo += 1;
                  ChangeGroupNo := false;
                end;

                ChangeGroupNo := "New Page";


                Totaldebit:=0;
                Totalcredit:=0;
                Totaldebitbal:=0;
                Totalcreditbal:=0;


                CalcFields("Net Change","Balance at Date");
                CurrReport.CreateTotals("Net Change","Balance at Date");

                if "G/L Account"."Account Type"="G/L Account"."account type"::Posting then
                begin
                if "Net Change">0 then
                Totaldebit:=Totaldebit+"Net Change";
                if "Net Change"<0 then
                Totalcredit:=Totalcredit+"Net Change";
                end;

                if "G/L Account"."Account Type"="G/L Account"."account type"::Posting then
                begin
                if "Balance at Date">0 then
                Totaldebitbal:=Totaldebitbal+"Balance at Date";
                if "Balance at Date"<0 then
                Totalcreditbal:=Totalcreditbal+"Balance at Date";
                end;
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
                    field(PrintToExcel;PrintToExcel)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print to Excel';
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
        GLFilter := "G/L Account".GetFilters;
        PeriodText := "G/L Account".GetFilter("Date Filter");
    end;

    var
        Text000: label 'Period: %1';
        GLFilter: Text[250];
        PeriodText: Text[30];
        Totaldebit: Decimal;
        Totalcredit: Decimal;
        Totaldebitbal: Decimal;
        Totalcreditbal: Decimal;
        Trial_BalanceCaptionLbl: label 'Trial Balance';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        EMAIL_admin_cuc_ac_keCaptionLbl: label 'EMAIL:info@karu.ac.ke';
        FAX_0202310302CaptionLbl: label 'FAX:0202310302';
        TEL_254_020_2310512CaptionLbl: label 'TEL:254-020 2310512';
        P_O_BOX_109_60400__kilimamboCaptionLbl: label 'P.O BOX 232-10103, KARATINA';
        No_CaptionLbl: label 'No.';
        PADSTR_____G_L_Account__Indentation___3___G_L_Account__NameCaptionLbl: label 'Name';
        G_L_Account___Net_Change_CaptionLbl: label 'Debit';
        G_L_Account___Net_Change__Control22CaptionLbl: label 'Credit';
        TotalsCaptionLbl: label 'Totals';
        ExcelBuf: Record "Excel Buffer" temporary;
        PrintToExcel: Boolean;
        PageGroupNo: Integer;
        ChangeGroupNo: Boolean;
        BlankLineNo: Integer;
        CompanyInformation: Record "Company Information";
        Text001: label 'Trial Balance';
        Text002: label 'Data';
        Text003: label 'Debit';
        Text004: label 'Credit';
        Text005: label 'Company Name';
        Text006: label 'Report No.';
        Text007: label 'Report Name';
        Text008: label 'User ID';
        Text009: label 'Date';
        Text010: label 'G/L Filter';
        Text011: label 'Period Filter';
        Net_ChangeCaptionLbl: label 'Net Change';
        BalanceCaptionLbl: label 'Balance';
        PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl: label 'Name';
        G_L_Account___Balance_at_Date_CaptionLbl: label 'Debit';
        G_L_Account___Balance_at_Date__Control24CaptionLbl: label 'Credit';


    procedure MakeExcelInfo()
    begin
        /*ExcelBuf.SetUseInfoSheet;
        //ExcelBuf.AddInfoColumn(FORMAT(Text005),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(COMPANYNAME,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text007),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(FORMAT(Text001),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text006),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(REPORT::"Trial Balance",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Number);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text008),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(USERID,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text009),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(TODAY,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Date);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text010),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn("G/L Account".GETFILTER("No."),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text011),FALSE,'',TRUE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn("G/L Account".GETFILTER("Date Filter"),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuf."Cell Type"::Text);
        ExcelBuf.ClearNewRow;
        MakeExcelDataHeader;*/

    end;

    local procedure MakeExcelDataHeader()
    begin
        ExcelBuf.AddColumn("G/L Account".FieldCaption("No."),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Account".FieldCaption(Name),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(
          Format("G/L Account".FieldCaption("Net Change") + ' - ' + Text003),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(
          Format("G/L Account".FieldCaption("Net Change") + ' - ' + Text004),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(
          Format("G/L Account".FieldCaption("Balance at Date") + ' - ' + Text003),false,'',true,false,true,'',
          ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(
          Format("G/L Account".FieldCaption("Balance at Date") + ' - ' + Text004),false,'',true,false,true,'',
          ExcelBuf."cell type"::Text);
    end;


    procedure MakeExcelDataBody()
    var
        BlankFiller: Text[250];
    begin
        BlankFiller := PadStr(' ',MaxStrLen(BlankFiller),' ');
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(
          "G/L Account"."No.",false,'',"G/L Account"."Account Type" <> "G/L Account"."account type"::Posting,false,false,'',
          ExcelBuf."cell type"::Text);
        if "G/L Account".Indentation = 0 then
          ExcelBuf.AddColumn(
            "G/L Account".Name,false,'',"G/L Account"."Account Type" <> "G/L Account"."account type"::Posting,false,false,'',
            ExcelBuf."cell type"::Text)
        else
          ExcelBuf.AddColumn(
            CopyStr(BlankFiller,1,2 * "G/L Account".Indentation) + "G/L Account".Name,
            false,'',"G/L Account"."Account Type" <> "G/L Account"."account type"::Posting,false,false,'',ExcelBuf."cell type"::Text);

        case true of
          "G/L Account"."Net Change" = 0:
            begin
              ExcelBuf.AddColumn(
                '',false,'',"G/L Account"."Account Type" <> "G/L Account"."account type"::Posting,false,false,'',
                ExcelBuf."cell type"::Text);
              ExcelBuf.AddColumn(
                '',false,'',"G/L Account"."Account Type" <> "G/L Account"."account type"::Posting,false,false,'',
                ExcelBuf."cell type"::Text);
            end;
          "G/L Account"."Net Change" > 0:
            begin
              ExcelBuf.AddColumn(
                "G/L Account"."Net Change",false,'',"G/L Account"."Account Type" <> "G/L Account"."account type"::Posting,
                false,false,'#,##0.00',ExcelBuf."cell type"::Number);
              ExcelBuf.AddColumn(
                '',false,'',"G/L Account"."Account Type" <> "G/L Account"."account type"::Posting,false,false,'',
                ExcelBuf."cell type"::Text);
            end;
          "G/L Account"."Net Change" < 0:
            begin
              ExcelBuf.AddColumn(
                '',false,'',"G/L Account"."Account Type" <> "G/L Account"."account type"::Posting,false,false,'',
                ExcelBuf."cell type"::Text);
              ExcelBuf.AddColumn(
                -"G/L Account"."Net Change",false,'',"G/L Account"."Account Type" <> "G/L Account"."account type"::Posting,
                false,false,'#,##0.00',ExcelBuf."cell type"::Number);
            end;
        end;

        case true of
          "G/L Account"."Balance at Date" = 0:
            begin
              ExcelBuf.AddColumn(
                '',false,'',"G/L Account"."Account Type" <> "G/L Account"."account type"::Posting,false,false,'',
                ExcelBuf."cell type"::Text);
              ExcelBuf.AddColumn(
                '',false,'',"G/L Account"."Account Type" <> "G/L Account"."account type"::Posting,false,false,'',
                ExcelBuf."cell type"::Text);
            end;
          "G/L Account"."Balance at Date" > 0:
            begin
              ExcelBuf.AddColumn(
                "G/L Account"."Balance at Date",false,'',"G/L Account"."Account Type" <> "G/L Account"."account type"::Posting,
                false,false,'#,##0.00',ExcelBuf."cell type"::Number);
              ExcelBuf.AddColumn(
                '',false,'',"G/L Account"."Account Type" <> "G/L Account"."account type"::Posting,false,false,'',
                ExcelBuf."cell type"::Text);
            end;
          "G/L Account"."Balance at Date" < 0:
            begin
              ExcelBuf.AddColumn(
                '',false,'',"G/L Account"."Account Type" <> "G/L Account"."account type"::Posting,false,false,'',
                ExcelBuf."cell type"::Text);
              ExcelBuf.AddColumn(
                -"G/L Account"."Balance at Date",false,'',"G/L Account"."Account Type" <> "G/L Account"."account type"::Posting,
                false,false,'#,##0.00',ExcelBuf."cell type"::Number);
            end;
        end;
    end;


    procedure CreateExcelbook()
    begin
        //ExcelBuf.CreateBookAndOpenExcel(Text002,Text001,COMPANYNAME,USERID);
        Error('');
    end;
}

