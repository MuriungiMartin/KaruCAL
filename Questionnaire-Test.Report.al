#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5067 "Questionnaire - Test"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Questionnaire - Test.rdlc';
    Caption = 'Questionnaire - Test';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Profile Questionnaire Header";"Profile Questionnaire Header")
        {
            RequestFilterFields = "Code";
            column(ReportForNavId_1883; 1883)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(Profile_Questionnaire_Header_Code;Code)
            {
            }
            column(Profile_Questionnaire_LineCaption;Profile_Questionnaire_LineCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Profile_Questionnaire_Line_DescriptionCaption;"Profile Questionnaire Line".FieldCaption(Description))
            {
            }
            column(Profile_Questionnaire_Line_TypeCaption;"Profile Questionnaire Line".FieldCaption(Type))
            {
            }
            column(Profile_Questionnaire_Line__Line_No__Caption;"Profile Questionnaire Line".FieldCaption("Line No."))
            {
            }
            dataitem("Profile Questionnaire Line";"Profile Questionnaire Line")
            {
                DataItemLink = "Profile Questionnaire Code"=field(Code);
                DataItemTableView = sorting("Profile Questionnaire Code","Line No.");
                column(ReportForNavId_4858; 4858)
                {
                }
                column(Profile_Questionnaire_Line__Line_No__;"Line No.")
                {
                }
                column(Profile_Questionnaire_Line_Type;Type)
                {
                }
                column(Profile_Questionnaire_Line_Description;Description)
                {
                }
                dataitem("Integer";"Integer")
                {
                    DataItemTableView = sorting(Number);
                    column(ReportForNavId_5444; 5444)
                    {
                    }
                    column(ErrorText_Number_;ErrorText[Number])
                    {
                    }
                    column(ErrorText_Number_Caption;ErrorText_Number_CaptionLbl)
                    {
                    }

                    trigger OnPostDataItem()
                    begin
                        ErrorCounter := 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange(Number,1,ErrorCounter);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    case Type of
                      Type::Question:
                        TestQuestion;
                      Type::Answer:
                        TestAnswer;
                    end;
                end;
            }
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
        Text000: label 'You must specify the Class. Field when %1 is set.';
        Text002: label '%1 must be specified when %2 is set.';
        Text003: label '%1 must be specified when %2 = %3.';
        Text004: label 'No Answer created.';
        Text005: label '%1 and/or %2 must be specified.';
        Text006: label '%1 cannot be %2 when %3 is %4.';
        Text007: label 'No Question created.';
        ProfileQuestnLine: Record "Profile Questionnaire Line";
        ProfileQuestnLine2: Record "Profile Questionnaire Line";
        ErrorCounter: Integer;
        ErrorText: array [50] of Text[250];
        Profile_Questionnaire_LineCaptionLbl: label 'Profile Questionnaire Line';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        ErrorText_Number_CaptionLbl: label 'Warning!';

    local procedure TestQuestion()
    begin
        ProfileQuestnLine.Reset;
        ProfileQuestnLine2.Reset;
        with "Profile Questionnaire Line" do begin
          if "Auto Contact Classification" then begin
            if ("Customer Class. Field" = "customer class. field"::" ") and
               ("Vendor Class. Field" = "vendor class. field"::" ") and
               ("Contact Class. Field" = "contact class. field"::" ")
            then
              AddError(StrSubstNo(Text000,FieldCaption("Auto Contact Classification")));
            if "Contact Class. Field" <> "contact class. field"::Rating then begin
              if Format("Starting Date Formula") = '' then
                AddError(StrSubstNo(
                    Text002,
                    FieldCaption("Starting Date Formula"),FieldCaption("Auto Contact Classification")));
              if Format("Ending Date Formula") = '' then
                AddError(StrSubstNo(
                    Text002,
                    FieldCaption("Ending Date Formula"),FieldCaption("Auto Contact Classification")));
            end;
            if "Classification Method" = "classification method"::" " then
              AddError(StrSubstNo(
                  Text002,
                  FieldCaption("Classification Method"),FieldCaption("Auto Contact Classification")));
            if ("Classification Method"
                in ["classification method"::"Percentage of Value","classification method"::"Percentage of Contacts"]) and
               ("Sorting Method" = "sorting method"::" ")
            then
              AddError(StrSubstNo(
                  Text003,
                  FieldCaption("Sorting Method"),FieldCaption("Classification Method"),"Classification Method"));
          end;
          ProfileQuestnLine := "Profile Questionnaire Line";
          ProfileQuestnLine.SetRange("Profile Questionnaire Code","Profile Questionnaire Code");
          ProfileQuestnLine.SetRange(Type,Type::Question);
          if ProfileQuestnLine.Find('>') then
            ProfileQuestnLine2.SetRange("Line No.","Line No.",ProfileQuestnLine."Line No.")
          else
            ProfileQuestnLine2.SetFilter("Line No.",'%1..',"Line No.");
          ProfileQuestnLine2.SetRange("Profile Questionnaire Code","Profile Questionnaire Code");
          ProfileQuestnLine2.SetRange(Type,Type::Answer);
          if not ProfileQuestnLine2.FindFirst then
            AddError(Text004);
        end;
    end;

    local procedure TestAnswer()
    begin
        ProfileQuestnLine.Reset;
        ProfileQuestnLine2.Reset;
        with "Profile Questionnaire Line" do begin
          ProfileQuestnLine := "Profile Questionnaire Line";
          ProfileQuestnLine.SetRange("Profile Questionnaire Code","Profile Questionnaire Code");
          ProfileQuestnLine.SetRange(Type,Type::Question);
          if ProfileQuestnLine.Find('<') then begin
            if ProfileQuestnLine."Auto Contact Classification" and
               ("From Value" = 0) and ("To Value" = 0)
            then
              AddError(StrSubstNo(
                  Text005,FieldCaption("From Value"),FieldCaption("To Value")));
            if "From Value" <> ROUND("From Value",1 / Power(10,ProfileQuestnLine."No. of Decimals")) then
              AddError(StrSubstNo(
                  Text006,FieldCaption("From Value"),"From Value",
                  FieldCaption("No. of Decimals"),ProfileQuestnLine."No. of Decimals"));
            if "To Value" <> ROUND("To Value",1 / Power(10,ProfileQuestnLine."No. of Decimals")) then
              AddError(StrSubstNo(
                  Text006,FieldCaption("To Value"),"To Value",
                  FieldCaption("No. of Decimals"),ProfileQuestnLine."No. of Decimals"));
          end else
            AddError(Text007);
        end;
    end;

    local procedure AddError(Text: Text[250])
    begin
        ErrorCounter := ErrorCounter + 1;
        ErrorText[ErrorCounter] := Text;
    end;
}

