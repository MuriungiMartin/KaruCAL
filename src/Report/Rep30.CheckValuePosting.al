#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 30 "Check Value Posting"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Check Value Posting.rdlc';
    Caption = 'Check Value Posting';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Integer";"Integer")
        {
            DataItemTableView = sorting(Number) where(Number=const(1));
            PrintOnlyIfDetail = true;
            column(ReportForNavId_5444; 5444)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(ValuePosting_DefaultDim1Caption;DefaultDim1.FieldCaption("Value Posting"))
            {
            }
            column(DimValueCode_DefaultDim1Caption;DefaultDim1.FieldCaption("Dimension Value Code"))
            {
            }
            column(DimensionCode_DefaultDim1Caption;DefaultDim1.FieldCaption("Dimension Code"))
            {
            }
            column(TableName_DefaultDim1Caption;DefaultDim1.FieldCaption("Table Caption"))
            {
            }
            column(TableID_DefaultDim1Caption;DefaultDim1.FieldCaption("Table ID"))
            {
            }
            column(AccountNoCaption;AccountNoCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(CheckValuePostingCaption;CheckValuePostingCaptionLbl)
            {
            }
            dataitem(DefaultDim1;"Default Dimension")
            {
                DataItemTableView = sorting("Table ID","No.","Dimension Code") where("No."=filter(''));
                PrintOnlyIfDetail = true;
                RequestFilterFields = "Dimension Code";
                column(ReportForNavId_2224; 2224)
                {
                }
                column(DimensionCode_DefaultDim1;"Dimension Code")
                {
                }
                column(DimValueCode_DefaultDim1;"Dimension Value Code")
                {
                }
                column(ValuePosting_DefaultDim1;"Value Posting")
                {
                }
                column(TableName_DefaultDim1;"Table Caption")
                {
                }
                column(TableID_DefaultDim1;"Table ID")
                {
                }
                dataitem(DefaultDim2;"Default Dimension")
                {
                    DataItemLink = "Table ID"=field("Table ID"),"Dimension Code"=field("Dimension Code");
                    DataItemLinkReference = DefaultDim1;
                    DataItemTableView = sorting("Table ID","No.","Dimension Code") where("No."=filter(<>''));
                    column(ReportForNavId_1272; 1272)
                    {
                    }
                    column(ValuePosting_DefaultDim2;"Value Posting")
                    {
                    }
                    column(DimValueCode_DefaultDim2;"Dimension Value Code")
                    {
                    }
                    column(DimensionCode_DefaultDim2;"Dimension Code")
                    {
                    }
                    column(No_DefaultDim2;"No.")
                    {
                    }
                    column(ErrorMessage_DefaultDim2;ErrorMessage)
                    {
                    }
                    column(ErrorCaption;ErrorCaptionLbl)
                    {
                    }
                    dataitem(DefaultDim3;"Default Dimension")
                    {
                        DataItemLink = "Dimension Code"=field("Dimension Code");
                        DataItemLinkReference = DefaultDim1;
                        DataItemTableView = sorting("Table ID","No.","Dimension Code");
                        column(ReportForNavId_6181; 6181)
                        {
                        }
                        column(ErrorMessage_DefaultDim3;ErrorMessage)
                        {
                        }
                        column(DimensionCode_DefaultDim3;"Dimension Code")
                        {
                        }
                        column(ValuePosting_DefaultDim3;"Value Posting")
                        {
                        }
                        column(DimValueCode_DefaultDim3;"Dimension Value Code")
                        {
                        }
                        column(TableID_DefaultDim3;"Table ID")
                        {
                        }
                        column(ErrorCaptionDefaultDim3;ErrorCaptionDefaultDim3Lbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            ErrorMessage := '';

                            CheckAndMakeErrorMessage(DefaultDim1,DefaultDim3,ErrorMessage);

                            if ErrorMessage = '' then
                              CurrReport.Skip;
                        end;

                        trigger OnPreDataItem()
                        begin
                            "Table Caption" := ObjectTransl.TranslateObject(ObjectTransl."object type"::Table,"Table ID");
                            if DefaultDim1."Table ID" = Database::Customer then
                              if Cust.Get(DefaultDim2."No.") then begin
                                SetRange("Table ID",Database::"Salesperson/Purchaser");
                                SetRange("No.",Cust."Salesperson Code");
                              end;

                            if DefaultDim1."Table ID" = Database::Vendor then
                              if Vend.Get(DefaultDim2."No.") then begin
                                SetRange("Table ID",Database::"Salesperson/Purchaser");
                                SetRange("No.",Vend."Purchaser Code");
                              end;

                            if (DefaultDim1."Table ID" <> Database::Customer) and
                               (DefaultDim1."Table ID" <> Database::Vendor)
                            then
                              CurrReport.Break;
                        end;
                    }
                    dataitem(DefaultDim4;"Default Dimension")
                    {
                        DataItemLink = "Dimension Code"=field("Dimension Code");
                        DataItemLinkReference = DefaultDim1;
                        DataItemTableView = sorting("Table ID","No.","Dimension Code");
                        column(ReportForNavId_2198; 2198)
                        {
                        }
                        column(ErrorMessage_DefaultDim4;ErrorMessage)
                        {
                        }
                        column(TableName_DefaultDim4;"Table Caption")
                        {
                        }
                        column(DimensionCode_DefaultDim4;"Dimension Code")
                        {
                        }
                        column(DimValueCode_DefaultDim4;"Dimension Value Code")
                        {
                        }
                        column(ValuePosting_DefaultDim4;"Value Posting")
                        {
                        }
                        column(ErrorCaptionDefaultDim4;ErrorCaptionDefaultDim4Lbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            ErrorMessage := '';

                            CheckAndMakeErrorMessage(DefaultDim1,DefaultDim4,ErrorMessage);

                            if ErrorMessage = '' then
                              CurrReport.Skip;
                        end;

                        trigger OnPreDataItem()
                        begin
                            "Table Caption" := ObjectTransl.TranslateObject(ObjectTransl."object type"::Table,"Table ID");
                            if DefaultDim1."Table ID" = Database::Customer then
                              if Cust.Get(DefaultDim2."No.") then begin
                                SetRange("Table ID",Database::"Responsibility Center");
                                SetRange("No.",Cust."Responsibility Center");
                              end;

                            if DefaultDim1."Table ID" = Database::Vendor then
                              if Vend.Get(DefaultDim2."No.") then begin
                                SetRange("Table ID",Database::"Responsibility Center");
                                SetRange("No.",Vend."Responsibility Center");
                              end;

                            if (DefaultDim1."Table ID" <> Database::Customer) and
                               (DefaultDim1."Table ID" <> Database::Vendor)
                            then
                              CurrReport.Break;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        "Table Caption" := ObjectTransl.TranslateObject(ObjectTransl."object type"::Table,"Table ID");
                        ErrorMessage := '';

                        CheckAndMakeErrorMessage(DefaultDim1,DefaultDim2,ErrorMessage);

                        if ErrorMessage = '' then
                          CurrReport.Skip;
                    end;

                    trigger OnPostDataItem()
                    begin
                        CurrReport.Break;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    "Table Caption" := ObjectTransl.TranslateObject(ObjectTransl."object type"::Table,"Table ID");
                    DefaultDimBuffer."Table ID" := "Table ID";

                    if not DefaultDimBuffer.Find then
                      DefaultDimBuffer := DefaultDim1;
                end;

                trigger OnPostDataItem()
                begin
                    CurrReport.Break;
                end;
            }
            dataitem(DefaultDim5;"Default Dimension")
            {
                DataItemTableView = sorting("Table ID","No.","Dimension Code") where("Table ID"=filter(18..23),"No."=filter(<>''));
                PrintOnlyIfDetail = true;
                column(ReportForNavId_1246; 1246)
                {
                }
                column(No_DefaultDim5;"No.")
                {
                }
                column(DimensionCode_DefaultDim5;"Dimension Code")
                {
                }
                column(DimValueCode_DefaultDim5;"Dimension Value Code")
                {
                }
                column(ValuePosting_DefaultDim5;"Value Posting")
                {
                }
                dataitem(DefaultDim6;"Default Dimension")
                {
                    DataItemLink = "Dimension Code"=field("Dimension Code");
                    DataItemLinkReference = DefaultDim5;
                    DataItemTableView = sorting("Table ID","No.","Dimension Code");
                    column(ReportForNavId_6155; 6155)
                    {
                    }
                    column(ErrorMessage_DefaultDim6;ErrorMessage)
                    {
                    }
                    column(TableName_DefaultDim6;"Table Caption")
                    {
                    }
                    column(DimensionCode_DefaultDim6;"Dimension Code")
                    {
                    }
                    column(DimValueCode_DefaultDim6;"Dimension Value Code")
                    {
                    }
                    column(ValuePosting_DefaultDim6;"Value Posting")
                    {
                    }
                    column(ErrorCaptionDefaultDim6;ErrorCaptionDefaultDim6Lbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        ErrorMessage := '';

                        CheckAndMakeErrorMessage(DefaultDim5,DefaultDim6,ErrorMessage);

                        if ErrorMessage = '' then
                          CurrReport.Skip;
                    end;

                    trigger OnPreDataItem()
                    begin
                        "Table Caption" := ObjectTransl.TranslateObject(ObjectTransl."object type"::Table,"Table ID");
                        if DefaultDim5."Table ID" = Database::Customer then
                          if Cust.Get(DefaultDim5."No.") then begin
                            SetRange("Table ID",Database::"Salesperson/Purchaser");
                            SetRange("No.",Cust."Salesperson Code");
                          end;

                        if DefaultDim5."Table ID" = Database::Vendor then
                          if Vend.Get(DefaultDim5."No.") then begin
                            SetRange("Table ID",Database::"Salesperson/Purchaser");
                            SetRange("No.",Vend."Purchaser Code");
                          end;
                    end;
                }
                dataitem(DefaultDim7;"Default Dimension")
                {
                    DataItemLink = "Dimension Code"=field("Dimension Code");
                    DataItemLinkReference = DefaultDim5;
                    DataItemTableView = sorting("Table ID","No.","Dimension Code");
                    column(ReportForNavId_2172; 2172)
                    {
                    }
                    column(ErrorMessage_DefaultDim7;ErrorMessage)
                    {
                    }
                    column(TableName_DefaultDim7;"Table Caption")
                    {
                    }
                    column(DimensionCode_DefaultDim7;"Dimension Code")
                    {
                    }
                    column(DimValueCode_DefaultDim7;"Dimension Value Code")
                    {
                    }
                    column(ValuePosting_DefaultDim7;"Value Posting")
                    {
                    }
                    column(ErrorCaptionDefaultDim7;ErrorCaptionDefaultDim7Lbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        ErrorMessage := '';

                        CheckAndMakeErrorMessage(DefaultDim5,DefaultDim7,ErrorMessage);

                        if ErrorMessage = '' then
                          CurrReport.Skip;
                    end;

                    trigger OnPreDataItem()
                    begin
                        "Table Caption" := ObjectTransl.TranslateObject(ObjectTransl."object type"::Table,"Table ID");
                        if DefaultDim5."Table ID" = Database::Customer then
                          if Cust.Get(DefaultDim5."No.") then begin
                            SetRange("Table ID",Database::"Responsibility Center");
                            SetRange("No.",Cust."Responsibility Center");
                          end;

                        if DefaultDim5."Table ID" = Database::Vendor then
                          if Vend.Get(DefaultDim5."No.") then begin
                            SetRange("Table ID",Database::"Responsibility Center");
                            SetRange("No.",Vend."Responsibility Center");
                          end;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    "Table Caption" := ObjectTransl.TranslateObject(ObjectTransl."object type"::Table,"Table ID");
                    DefaultDimBuffer."Table ID" := "Table ID";

                    if DefaultDimBuffer.Find then
                      CurrReport.Skip;
                end;

                trigger OnPostDataItem()
                begin
                    CurrReport.Break;
                end;
            }
            dataitem(DefaultDim8;"Default Dimension")
            {
                DataItemTableView = sorting("Table ID","No.","Dimension Code") where("Value Posting"=filter("No Code"));
                column(ReportForNavId_1220; 1220)
                {
                }
                column(ErrorMessage_DefaultDim8;ErrorMessage)
                {
                }
                column(ValuePosting_DefaultDim8;"Value Posting")
                {
                }
                column(DimValueCode_DefaultDim8;"Dimension Value Code")
                {
                }
                column(DimensionCode_DefaultDim8;"Dimension Code")
                {
                }
                column(No_DefaultDim8;"No.")
                {
                }
                column(TableID_DefaultDim8;"Table ID")
                {
                }
                column(TableName_DefaultDim8;"Table Caption")
                {
                }
                column(ErrorCaptionDefaultDim8;ErrorCaptionDefaultDim8Lbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    "Table Caption" := ObjectTransl.TranslateObject(ObjectTransl."object type"::Table,"Table ID");
                    ErrorMessage := '';

                    if "Dimension Value Code" <> '' then
                      ErrorMessage :=
                        StrSubstNo(
                          Text000,
                          "Dimension Value Code",
                          FieldCaption("Dimension Value Code"),
                          FieldCaption("Value Posting"),
                          "Value Posting")
                    else
                      CurrReport.Skip;
                end;

                trigger OnPreDataItem()
                begin
                    DefaultDim1.Copyfilter("Table ID","Table ID");
                    DefaultDim1.Copyfilter("Dimension Code","Dimension Code");
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
        Text000: label 'You must not use a "%1" %2 when %3 is "%4".';
        Text001: label '%1 must be %2.';
        Text002: label '%1 %2 is mandatory.';
        Text003: label '%1 %2 must not be mentioned.';
        Text004: label '%1 %2 must be %3.';
        Cust: Record Customer;
        Vend: Record Vendor;
        DefaultDimBuffer: Record "Default Dimension" temporary;
        ObjectTransl: Record "Object Translation";
        ErrorMessage: Text[250];
        AccountNoCaptionLbl: label 'Account No.';
        CurrReportPageNoCaptionLbl: label 'Page';
        CheckValuePostingCaptionLbl: label 'Check Value Posting';
        ErrorCaptionLbl: label 'Error';
        ErrorCaptionDefaultDim3Lbl: label 'Error';
        ErrorCaptionDefaultDim4Lbl: label 'Error';
        ErrorCaptionDefaultDim6Lbl: label 'Error';
        ErrorCaptionDefaultDim7Lbl: label 'Error';
        ErrorCaptionDefaultDim8Lbl: label 'Error';

    local procedure CheckAndMakeErrorMessage(DefaultDim1: Record "Default Dimension";DefaultDim2: Record "Default Dimension";var ErrorMessage: Text[250])
    begin
        case DefaultDim1."Value Posting" of
          DefaultDim1."value posting"::" ":
            if (((DefaultDim2."Value Posting" = DefaultDim2."value posting"::"Same Code") and
                 (DefaultDim2."Dimension Value Code" = '')) or
                (DefaultDim2."Value Posting" = DefaultDim2."value posting"::"No Code")) and
               (DefaultDim2."Dimension Value Code" <> '')
            then
              ErrorMessage :=
                StrSubstNo(
                  Text001,
                  DefaultDim2.FieldCaption("Dimension Value Code"),DefaultDim1."Dimension Value Code");
          DefaultDim1."value posting"::"Code Mandatory":
            if (DefaultDim2."Value Posting" = DefaultDim2."value posting"::"No Code") or
               ((DefaultDim2."Value Posting" = DefaultDim2."value posting"::"Same Code") and
                (DefaultDim2."Dimension Value Code" = ''))
            then
              ErrorMessage :=
                StrSubstNo(
                  Text002,
                  DefaultDim1.FieldCaption("Dimension Code"),DefaultDim1."Dimension Code");
          DefaultDim1."value posting"::"Same Code":
            case DefaultDim2."Value Posting" of
              DefaultDim2."value posting"::"Code Mandatory":
                if DefaultDim1."Dimension Value Code" = '' then
                  ErrorMessage :=
                    StrSubstNo(
                      Text003,
                      DefaultDim1.FieldCaption("Dimension Code"),DefaultDim1."Dimension Code")
                else
                  if (DefaultDim2."Dimension Value Code" <> '') and
                     (DefaultDim1."Dimension Value Code" <> DefaultDim2."Dimension Value Code")
                  then
                    ErrorMessage :=
                      StrSubstNo(
                        Text004,
                        DefaultDim2.FieldCaption("Dimension Value Code"),DefaultDim2."Dimension Value Code",
                        DefaultDim1."Dimension Value Code");
              DefaultDim2."value posting"::"No Code":
                if DefaultDim1."Dimension Value Code" <> '' then
                  ErrorMessage :=
                    StrSubstNo(
                      Text001,
                      DefaultDim1.FieldCaption("Dimension Value Code"),DefaultDim1."Dimension Value Code");
              DefaultDim2."value posting"::"Same Code",DefaultDim2."value posting"::" ":
                if DefaultDim1."Dimension Value Code" <> DefaultDim2."Dimension Value Code" then
                  if DefaultDim1."Dimension Value Code" = '' then
                    ErrorMessage :=
                      StrSubstNo(
                        Text003,
                        DefaultDim1.FieldCaption("Dimension Code"),DefaultDim1."Dimension Code")
                  else
                    ErrorMessage :=
                      StrSubstNo(
                        Text004,
                        DefaultDim2.FieldCaption("Dimension Value Code"),
                        DefaultDim2."Dimension Value Code",DefaultDim1."Dimension Value Code");
            end;
          DefaultDim1."value posting"::"No Code":
            if DefaultDim2."Dimension Value Code" <> '' then
              ErrorMessage :=
                StrSubstNo(
                  Text003,
                  DefaultDim1.FieldCaption("Dimension Code"),DefaultDim1."Dimension Code");
        end;
    end;
}

