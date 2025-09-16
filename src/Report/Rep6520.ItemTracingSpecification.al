#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 6520 "Item Tracing Specification"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Item Tracing Specification.rdlc';
    Caption = 'Item Tracing Specification';

    dataset
    {
        dataitem("Integer";"Integer")
        {
            DataItemTableView = sorting(Number);
            column(ReportForNavId_5444; 5444)
            {
            }
            column(FormatToday;Format(Today,0,4))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(HeaderText1;HeaderText[1])
            {
            }
            column(HeaderText2;HeaderText[2])
            {
            }
            column(HeaderText3;HeaderText[3])
            {
            }
            column(HeaderText4;HeaderText[4])
            {
            }
            column(HeaderText5;HeaderText[5])
            {
            }
            column(HeaderText6;HeaderText[6])
            {
            }
            column(HeaderText7;HeaderText[7])
            {
            }
            column(HeaderText8;HeaderText[8])
            {
            }
            column(GlobVarX;x)
            {
            }
            column(TransactionDescription;TransactionDescription)
            {
                OptionMembers = Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output," ","Assembly Consumption","Assembly Output";
            }
            column(BodyText1;BodyText[1])
            {
            }
            column(BodyText2;BodyText[2])
            {
            }
            column(BodyText3;BodyText[3])
            {
            }
            column(BodyText4;BodyText[4])
            {
            }
            column(BodyText5;BodyText[5])
            {
            }
            column(BodyText6;BodyText[6])
            {
            }
            column(BodyText8;BodyText[8])
            {
            }
            column(BodyText7;BodyText[7])
            {
            }
            column(TempTrackEntrySourceType;TempTrackEntry."Source Type")
            {
                OptionMembers = " ,Customer,Vendor,Item";
            }
            column(TempTrackEntrySourceNo;TempTrackEntry."Source No.")
            {
            }
            column(TempTrackEntrySourceName;TempTrackEntry."Source Name")
            {
            }
            column(SecIntBody6ShowOutput;(PrintCustomer and (TempTrackEntry."Source Type" = TempTrackEntry."source type"::Customer)) or (PrintVendor and (TempTrackEntry."Source Type" = TempTrackEntry."source type"::Vendor)))
            {
            }
            column(ItemTracingSpecificationCaption;ItemTracingSpecificationCaptionLbl)
            {
            }
            column(PageCaption;PageCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if TempTrackEntry.Next = 0 then
                  CurrReport.Skip;

                TransactionDescription := PadStr('',TempTrackEntry.Level,'*') + Format(TempTrackEntry.Description);
                if not Item.Get(TempTrackEntry."Item No.") then
                  Clear(Item);

                Clear(RecRef);
                RecRef.Open(Database::"Item Tracing Buffer",true);
                RecRef.GetTable(TempTrackEntry);

                x := 0;
                Clear(BodyText);
                for i := 1 to ArrayLen(HeaderText) do
                  if FldNo[i] <> 0 then begin
                    FldRef := RecRef.Field(FldNo[i]);
                    x += 1;
                    if not HeaderTextCreated then
                      HeaderText[x] := FldRef.Caption;
                    if (i < 9) or
                       ((TempTrackEntry."Source Type" = TempTrackEntry."source type"::Customer) and PrintCustomer) or
                       ((TempTrackEntry."Source Type" = TempTrackEntry."source type"::Vendor) and PrintVendor)
                    then
                      BodyText[x] := Format(FldRef);
                  end;

                HeaderTextCreated := true;
            end;

            trigger OnPreDataItem()
            begin
                SetRange(Number,1,NoOfRecords);
                Clear(TempTrackEntry);

                HeaderTextCreated := false;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    group("Print Contact Information")
                    {
                        Caption = 'Print Contact Information';
                        field(Customer;PrintCustomer)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Customer';
                        }
                        field(Vendor;PrintVendor)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Vendor';
                        }
                    }
                    group("Column Selection")
                    {
                        Caption = 'Column Selection';
                        field("FldNo[1]";FldNo[1])
                        {
                            ApplicationArea = Basic;
                            BlankZero = true;
                            Caption = 'No. 1';

                            trigger OnLookup(var Text: Text): Boolean
                            begin
                                LookupField(1);
                            end;

                            trigger OnValidate()
                            begin
                                GetFieldValue(1,FldNo[1]);
                            end;
                        }
                        field("FldNo[2]";FldNo[2])
                        {
                            ApplicationArea = Basic;
                            BlankZero = true;
                            Caption = 'No. 2';

                            trigger OnLookup(var Text: Text): Boolean
                            begin
                                LookupField(2);
                            end;

                            trigger OnValidate()
                            begin
                                GetFieldValue(2,FldNo[2]);
                            end;
                        }
                        field("FldNo[3]";FldNo[3])
                        {
                            ApplicationArea = Basic;
                            BlankZero = true;
                            Caption = 'No. 3';

                            trigger OnLookup(var Text: Text): Boolean
                            begin
                                LookupField(3);
                            end;

                            trigger OnValidate()
                            begin
                                GetFieldValue(3,FldNo[3]);
                            end;
                        }
                        field("FldNo[4]";FldNo[4])
                        {
                            ApplicationArea = Basic;
                            BlankZero = true;
                            Caption = 'No. 4';

                            trigger OnLookup(var Text: Text): Boolean
                            begin
                                LookupField(4);
                            end;

                            trigger OnValidate()
                            begin
                                GetFieldValue(4,FldNo[4]);
                            end;
                        }
                        field("FldNo[5]";FldNo[5])
                        {
                            ApplicationArea = Basic;
                            BlankZero = true;
                            Caption = 'No. 5';

                            trigger OnLookup(var Text: Text): Boolean
                            begin
                                LookupField(5);
                            end;

                            trigger OnValidate()
                            begin
                                GetFieldValue(5,FldNo[5]);
                            end;
                        }
                        field("FldNo[6]";FldNo[6])
                        {
                            ApplicationArea = Basic;
                            BlankZero = true;
                            Caption = 'No. 6';

                            trigger OnLookup(var Text: Text): Boolean
                            begin
                                LookupField(6);
                            end;

                            trigger OnValidate()
                            begin
                                GetFieldValue(6,FldNo[6]);
                            end;
                        }
                        field("FldNo[7]";FldNo[7])
                        {
                            ApplicationArea = Basic;
                            BlankZero = true;
                            Caption = 'No. 7';

                            trigger OnLookup(var Text: Text): Boolean
                            begin
                                LookupField(7);
                            end;

                            trigger OnValidate()
                            begin
                                GetFieldValue(7,FldNo[7]);
                            end;
                        }
                        field("FldNo[8]";FldNo[8])
                        {
                            ApplicationArea = Basic;
                            BlankZero = true;
                            Caption = 'No. 8';

                            trigger OnLookup(var Text: Text): Boolean
                            begin
                                LookupField(8);
                            end;

                            trigger OnValidate()
                            begin
                                GetFieldValue(8,FldNo[8]);
                            end;
                        }
                    }
                    field("FieldCaption[1]";FieldCaption[1])
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                        ShowCaption = false;
                    }
                    field("FieldCaption[2]";FieldCaption[2])
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                        ShowCaption = false;
                    }
                    field("FieldCaption[3]";FieldCaption[3])
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                        ShowCaption = false;
                    }
                    field("FieldCaption[4]";FieldCaption[4])
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                        ShowCaption = false;
                    }
                    field("FieldCaption[5]";FieldCaption[5])
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                        ShowCaption = false;
                    }
                    field("FieldCaption[6]";FieldCaption[6])
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                        ShowCaption = false;
                    }
                    field("FieldCaption[7]";FieldCaption[7])
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                        ShowCaption = false;
                    }
                    field("FieldCaption[8]";FieldCaption[8])
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                        ShowCaption = false;
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
        DescriptionCaption = 'Description';
        EmptyStringCaption = '___________________________________________________________________________________________________________________________________________________________________________';
    }

    trigger OnPreReport()
    begin
        if TempTrackEntry.Find then
          NoOfRecords := TempTrackEntry.Count
        else
          NoOfRecords := 0;
    end;

    var
        Item: Record Item;
        TempTrackEntry: Record "Item Tracing Buffer" temporary;
        RecRef: RecordRef;
        FldRef: FieldRef;
        NoOfRecords: Integer;
        TransactionDescription: Text[100];
        PrintCustomer: Boolean;
        PrintVendor: Boolean;
        HeaderTextCreated: Boolean;
        HeaderText: array [11] of Text[50];
        BodyText: array [11] of Text[50];
        FieldCaption: array [11] of Text[50];
        FldNo: array [11] of Integer;
        i: Integer;
        x: Integer;
        ItemTracingSpecificationCaptionLbl: label 'Item Tracing Specification';
        PageCaptionLbl: label 'Page';


    procedure TransferEntries(var ItemTrackingEntry: Record "Item Tracing Buffer")
    begin
        ItemTrackingEntry.Reset;
        if ItemTrackingEntry.Find('-') then
          repeat
            TempTrackEntry := ItemTrackingEntry;
            TempTrackEntry.Insert;
          until ItemTrackingEntry.Next = 0;
    end;

    local procedure LookupField(FieldNumber: Integer)
    var
        "Field": Record "Field";
    begin
        Field.SetRange(TableNo,Database::"Item Tracing Buffer");
        Field.SetFilter(Type,
          '%1|%2|%3|%4|%5|%6|%7|%8',
          Field.Type::Text,
          Field.Type::Date,
          Field.Type::Decimal,
          Field.Type::Boolean,
          Field.Type::Code,
          Field.Type::Option,
          Field.Type::Integer,
          Field.Type::BigInteger);
        if Page.RunModal(Page::"Table Field List",Field,Field."No.") = Action::LookupOK then
          if FldNo[FieldNumber] <> Field."No." then begin
            FldNo[FieldNumber] := Field."No.";
            FieldCaption[FieldNumber] := Field."Field Caption";
          end;
    end;

    local procedure GetFieldValue(ArrayNo: Integer;FieldNumber: Integer)
    var
        "Field": Record "Field";
    begin
        if FieldNumber <> 0 then begin
          Field.Get(Database::"Item Tracing Buffer",FieldNumber);
          FieldCaption[ArrayNo] := Field."Field Caption";
        end else
          FieldCaption[ArrayNo] := '';
    end;
}

