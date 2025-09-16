#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5186 "Remove Contacts"
{
    Caption = 'Remove Contacts';
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Segment Header";"Segment Header")
        {
            DataItemTableView = sorting("No.");
            column(ReportForNavId_7133; 7133)
            {
            }
            dataitem("Segment Line";"Segment Line")
            {
                DataItemLink = "Segment No."=field("No.");
                DataItemTableView = sorting("Segment No.","Line No.");
                column(ReportForNavId_5030; 5030)
                {
                }
                dataitem(Contact;Contact)
                {
                    DataItemTableView = sorting("No.");
                    RequestFilterFields = "No.","Search Name",Type,"Salesperson Code","Post Code","Country/Region Code","Territory Code";
                    column(ReportForNavId_6698; 6698)
                    {
                    }
                    dataitem("Contact Profile Answer";"Contact Profile Answer")
                    {
                        DataItemLink = "Contact No."=field("No.");
                        RequestFilterHeading = 'Profile';
                        column(ReportForNavId_3762; 3762)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            ContactOK := true;
                            CurrReport.Break;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if ContactOK and (GetFilters <> '') then
                              ContactOK := false
                            else
                              CurrReport.Break;
                        end;
                    }
                    dataitem("Contact Mailing Group";"Contact Mailing Group")
                    {
                        DataItemLink = "Contact No."=field("No.");
                        DataItemTableView = sorting("Contact No.","Mailing Group Code");
                        RequestFilterFields = "Mailing Group Code";
                        RequestFilterHeading = 'Mailing Group';
                        column(ReportForNavId_6043; 6043)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            ContactOK := true;
                            CurrReport.Break;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if ContactOK and (GetFilters <> '') then
                              ContactOK := false
                            else
                              CurrReport.Break;
                        end;
                    }
                    dataitem("Interaction Log Entry";"Interaction Log Entry")
                    {
                        DataItemLink = "Contact Company No."=field("Company No."),"Contact No."=field("No.");
                        DataItemTableView = sorting("Contact Company No.","Contact No.",Date);
                        RequestFilterFields = Date,"Segment No.","Campaign No.",Evaluation,"Interaction Template Code","Salesperson Code";
                        column(ReportForNavId_3056; 3056)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            ContactOK := true;
                            CurrReport.Break;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if ContactOK and (GetFilters <> '') then
                              ContactOK := false
                            else
                              CurrReport.Break;
                        end;
                    }
                    dataitem("Contact Job Responsibility";"Contact Job Responsibility")
                    {
                        DataItemLink = "Contact No."=field("No.");
                        DataItemTableView = sorting("Contact No.","Job Responsibility Code");
                        RequestFilterFields = "Job Responsibility Code";
                        RequestFilterHeading = 'Job Responsibility';
                        column(ReportForNavId_6030; 6030)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            ContactOK := true;
                            CurrReport.Break;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if ContactOK and (GetFilters <> '') then
                              ContactOK := false
                            else
                              CurrReport.Break;
                        end;
                    }
                    dataitem("Contact Industry Group";"Contact Industry Group")
                    {
                        DataItemLink = "Contact No."=field("Company No.");
                        DataItemTableView = sorting("Contact No.","Industry Group Code");
                        RequestFilterFields = "Industry Group Code";
                        RequestFilterHeading = 'Industry Group';
                        column(ReportForNavId_4008; 4008)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            ContactOK := true;
                            CurrReport.Break;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if ContactOK and (GetFilters <> '') then
                              ContactOK := false
                            else
                              CurrReport.Break;
                        end;
                    }
                    dataitem("Contact Business Relation";"Contact Business Relation")
                    {
                        DataItemLink = "Contact No."=field("Company No.");
                        DataItemTableView = sorting("Contact No.","Business Relation Code");
                        RequestFilterFields = "Business Relation Code";
                        RequestFilterHeading = 'Business Relation';
                        column(ReportForNavId_8768; 8768)
                        {
                        }
                        dataitem("Value Entry";"Value Entry")
                        {
                            DataItemTableView = sorting("Source Type","Source No.","Item No.","Posting Date");
                            RequestFilterFields = "Item No.","Variant Code","Posting Date","Inventory Posting Group";
                            column(ReportForNavId_8894; 8894)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                ContactOK := true;
                                CurrReport.Break;
                            end;

                            trigger OnPreDataItem()
                            begin
                                if SkipItemLedgerEntry then
                                  CurrReport.Break;

                                case "Contact Business Relation"."Link to Table" of
                                  "Contact Business Relation"."link to table"::Customer:
                                    begin
                                      SetRange("Source Type","source type"::Customer);
                                      SetRange("Source No.","Contact Business Relation"."No.");
                                    end;
                                  "Contact Business Relation"."link to table"::Vendor:
                                    begin
                                      SetRange("Source Type","source type"::Vendor);
                                      SetRange("Source No.","Contact Business Relation"."No.");
                                    end
                                  else
                                    CurrReport.Break;
                                end;
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            SkipItemLedgerEntry := false;
                            if not ItemFilters then begin
                              ContactOK := true;
                              SkipItemLedgerEntry := true;
                              CurrReport.Break;
                            end;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if ContactOK and ((GetFilters <> '') or ItemFilters) then
                              ContactOK := false
                            else
                              CurrReport.Break;
                        end;
                    }
                    dataitem("Integer";"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=const(1));
                        column(ReportForNavId_5444; 5444)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if ContactOK then
                              InsertContact(Contact);
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if EntireCompanies then begin
                          if TempCheckCont.Get("No.") then
                            CurrReport.Skip;
                          TempCheckCont := Contact;
                          TempCheckCont.Insert;
                        end;

                        ContactOK := true;
                    end;

                    trigger OnPreDataItem()
                    begin
                        FilterGroup(4);
                        SetRange("Company No.","Segment Line"."Contact Company No.");
                        if not EntireCompanies then
                          SetRange("No.","Segment Line"."Contact No.");
                        FilterGroup(0);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    RecordNo := RecordNo + 1;
                    if RecordNo = 1 then begin
                      OldTime := Time;
                      case MainReportNo of
                        Report::"Remove Contacts - Reduce":
                          Window.Open(Text000);
                        Report::"Remove Contacts - Refine":
                          Window.Open(Text001);
                      end;
                      NoOfRecords := Count;
                    end;
                    NewTime := Time;
                    if (NewTime - OldTime > 100) or (NewTime < OldTime) then begin
                      NewProgress := ROUND(RecordNo / NoOfRecords * 100,1);
                      if NewProgress <> OldProgress then begin
                        Window.Update(1,NewProgress * 100);
                        OldProgress := NewProgress;
                      end;
                      OldTime := Time;
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

    trigger OnPostReport()
    begin
        if EntireCompanies then
          AddPeople;

        UpdateSegLines;
    end;

    trigger OnPreReport()
    begin
        ItemFilters := "Value Entry".HasFilter;

        SegCriteriaManagement.InsertCriteriaAction(
          "Segment Header".GetFilter("No."),MainReportNo,
          false,false,false,false,EntireCompanies);
        SegCriteriaManagement.InsertCriteriaFilter(
          "Segment Header".GetFilter("No."),Database::Contact,
          Contact.GetFilters,Contact.GetView(false));
        SegCriteriaManagement.InsertCriteriaFilter(
          "Segment Header".GetFilter("No."),Database::"Contact Profile Answer",
          "Contact Profile Answer".GetFilters,"Contact Profile Answer".GetView(false));
        SegCriteriaManagement.InsertCriteriaFilter(
          "Segment Header".GetFilter("No."),Database::"Contact Mailing Group",
          "Contact Mailing Group".GetFilters,"Contact Mailing Group".GetView(false));
        SegCriteriaManagement.InsertCriteriaFilter(
          "Segment Header".GetFilter("No."),Database::"Interaction Log Entry",
          "Interaction Log Entry".GetFilters,"Interaction Log Entry".GetView(false));
        SegCriteriaManagement.InsertCriteriaFilter(
          "Segment Header".GetFilter("No."),Database::"Contact Job Responsibility","Contact Job Responsibility".GetFilters,
          "Contact Job Responsibility".GetView(false));
        SegCriteriaManagement.InsertCriteriaFilter(
          "Segment Header".GetFilter("No."),Database::"Contact Industry Group",
          "Contact Industry Group".GetFilters,"Contact Industry Group".GetView(false));
        SegCriteriaManagement.InsertCriteriaFilter(
          "Segment Header".GetFilter("No."),Database::"Contact Business Relation",
          "Contact Business Relation".GetFilters,"Contact Business Relation".GetView(false));
        SegCriteriaManagement.InsertCriteriaFilter(
          "Segment Header".GetFilter("No."),Database::"Value Entry",
          "Value Entry".GetFilters,"Value Entry".GetView(false));
    end;

    var
        Text000: label 'Reducing Contacts @1@@@@@@@@@@@@@';
        Text001: label 'Refining Contacts @1@@@@@@@@@@@@@';
        TempCont: Record Contact temporary;
        TempCont2: Record Contact temporary;
        TempCheckCont: Record Contact temporary;
        Cont: Record Contact;
        SegLine: Record "Segment Line";
        SegmentHistoryMgt: Codeunit SegHistoryManagement;
        SegCriteriaManagement: Codeunit SegCriteriaManagement;
        Window: Dialog;
        MainReportNo: Integer;
        ItemFilters: Boolean;
        ContactOK: Boolean;
        EntireCompanies: Boolean;
        SkipItemLedgerEntry: Boolean;
        NoOfRecords: Integer;
        RecordNo: Integer;
        OldTime: Time;
        NewTime: Time;
        OldProgress: Integer;
        NewProgress: Integer;


    procedure SetOptions(CalledFromReportNo: Integer;OptionEntireCompanies: Boolean)
    begin
        MainReportNo := CalledFromReportNo;
        EntireCompanies := OptionEntireCompanies;
    end;

    local procedure InsertContact(var CheckedCont: Record Contact)
    begin
        TempCont := CheckedCont;
        if TempCont.Insert then;
    end;

    local procedure AddPeople()
    begin
        TempCont.Reset;
        if TempCont.Find('-') then
          repeat
            if TempCont."Company No." <> '' then begin
              Cont.SetCurrentkey("Company No.");
              Cont.SetRange("Company No.",TempCont."Company No.");
              if Cont.Find('-') then
                repeat
                  TempCont2 := Cont;
                  if TempCont2.Insert then;
                until Cont.Next = 0
            end else begin
              TempCont2 := TempCont;
              TempCont2.Insert;
            end;
          until TempCont.Next = 0;

        TempCont.DeleteAll;
        if TempCont2.Find('-') then
          repeat
            TempCont := TempCont2;
            TempCont.Insert;
          until TempCont2.Next = 0;
        TempCont2.DeleteAll;
    end;

    local procedure UpdateSegLines()
    begin
        SegLine.Reset;
        SegLine.SetRange("Segment No.","Segment Header"."No.");
        if SegLine.Find('-') then
          repeat
            case MainReportNo of
              Report::"Remove Contacts - Reduce":
                if TempCont.Get(SegLine."Contact No.") then begin
                  SegLine.Delete(true);
                  SegmentHistoryMgt.DeleteLine(
                    SegLine."Segment No.",SegLine."Contact No.",SegLine."Line No.");
                end;
              Report::"Remove Contacts - Refine":
                if not TempCont.Get(SegLine."Contact No.") then begin
                  SegLine.Delete(true);
                  SegmentHistoryMgt.DeleteLine(
                    SegLine."Segment No.",SegLine."Contact No.",SegLine."Line No.");
                end;
            end;
          until SegLine.Next = 0;
    end;
}

