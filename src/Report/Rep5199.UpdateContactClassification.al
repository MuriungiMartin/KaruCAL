#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5199 "Update Contact Classification"
{
    Caption = 'Update Contact Classification';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Profile Questionnaire Header";"Profile Questionnaire Header")
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code",Description,"Business Relation Code";
            column(ReportForNavId_1883; 1883)
            {
            }
            dataitem("Profile Questionnaire Line";"Profile Questionnaire Line")
            {
                DataItemLink = "Profile Questionnaire Code"=field(Code);
                DataItemTableView = sorting("Profile Questionnaire Code","Line No.") where(Type=const(Question),"Auto Contact Classification"=const(true),"Contact Class. Field"=filter(<>Rating));
                column(ReportForNavId_4858; 4858)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Window.Update(3,"Line No.");
                    if NoOfQuestions = 0 then
                      NoOfQuestions := Count;
                    QuestionCount := QuestionCount + 1;
                    Window.Update(4,ROUND(10000 * QuestionCount / NoOfQuestions,1));
                    RecCount := 0;

                    ContactValue.DeleteAll;

                    if (Format("Starting Date Formula") = '') or (Format("Ending Date Formula") = '') then
                      Error(
                        Text005,
                        FieldCaption("Starting Date Formula"),
                        FieldCaption("Ending Date Formula"),
                        "Profile Questionnaire Header".Code,
                        Description);

                    if "Classification Method" = "classification method"::" " then
                      Error(
                        Text008,
                        FieldCaption("Classification Method"),
                        "Profile Questionnaire Header".Code,
                        Description);

                    AnswersExists("Profile Questionnaire Line",'',true);
                    TotalValue := 0;

                    case true of
                      "Customer Class. Field" <> "customer class. field"::" ":
                        FindCustomerValues("Profile Questionnaire Line");
                      "Vendor Class. Field" <> "vendor class. field"::" ":
                        FindVendorValues("Profile Questionnaire Line");
                      "Contact Class. Field" <> "contact class. field"::" ":
                        FindContactValues("Profile Questionnaire Line");
                    end;

                    MarkContactByMethod("Profile Questionnaire Line",'');
                end;

                trigger OnPreDataItem()
                begin
                    NoOfQuestions := 0;
                    QuestionCount := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(1,Code);
                if NoOfProfiles = 0 then
                  NoOfProfiles := Count;
                ProfileCount := ProfileCount + 1;
                Window.Update(2,ROUND(10000 * ProfileCount / NoOfProfiles,1));
                NoOfQuestions := 0;
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
                UpdateRating('');
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
                    field(Date;Date)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Date';
                        ToolTip = 'Specifies the date on which you update the contact classification.';
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
        Date := WorkDate;
    end;

    trigger OnPreReport()
    begin
        Window.Open(
          Text000 +
          Text001 +
          Text002);
    end;

    var
        Text000: label 'Profile Questionnaire #1######## @2@@@@@@@@@@@@@\\';
        Text001: label 'Question Line No.     #3######## @4@@@@@@@@@@@@@\';
        Text002: label 'Finding Values        #5######## @6@@@@@@@@@@@@@\';
        Text003: label '%1 results in a date before the result of the %2.';
        ContactValue: Record "Contact Value" temporary;
        Window: Dialog;
        Date: Date;
        NoOfProfiles: Integer;
        ProfileCount: Integer;
        NoOfQuestions: Integer;
        QuestionCount: Integer;
        NoOfRecs: Integer;
        RecCount: Integer;
        TotalValue: Decimal;
        Text004: label 'Two or more questions are causing the rating calculation to loop.';
        Text005: label 'You must specify %1 and %2 in Profile Questionnaire %3, question %4. To find additional errors, run the Test report.', Comment='%1 = Starting Date Formula;%2 = Ending Date Formula;%3 = Profile Questionaire Code;%4 = Question Description';
        Text008: label 'You must specify %1 in Profile Questionnaire %2, question %3. To find additional errors, run the Test report.', Comment='%1 = Sorting Method;%2 = Profile Questionaire Code;%3 = Question Description';

    local procedure AnswersExists(var ProfileQuestionnaireLine: Record "Profile Questionnaire Line";UpdateContNo: Code[20];Delete: Boolean): Boolean
    var
        ContProfileAnswer: Record "Contact Profile Answer";
        ProfileQuestnLine2: Record "Profile Questionnaire Line";
    begin
        ContProfileAnswer.SetCurrentkey("Profile Questionnaire Code","Line No.");
        ContProfileAnswer.SetRange("Profile Questionnaire Code",ProfileQuestionnaireLine."Profile Questionnaire Code");

        ProfileQuestnLine2.Reset;
        ProfileQuestnLine2 := ProfileQuestionnaireLine;
        ProfileQuestnLine2.SetRange(Type,ProfileQuestnLine2.Type::Question);
        ProfileQuestnLine2.SetRange("Profile Questionnaire Code",ProfileQuestionnaireLine."Profile Questionnaire Code");
        if ProfileQuestnLine2.Next <> 0 then
          ContProfileAnswer.SetRange("Line No.",ProfileQuestionnaireLine."Line No.",ProfileQuestnLine2."Line No.")
        else
          ContProfileAnswer.SetFilter("Line No.",'%1..',ProfileQuestionnaireLine."Line No.");
        if UpdateContNo <> '' then begin
          ContProfileAnswer.SetRange("Contact No.",UpdateContNo);
          ContProfileAnswer.SetCurrentkey("Contact No.","Profile Questionnaire Code","Line No.");
        end;

        if Delete then
          ContProfileAnswer.DeleteAll
        else
          exit(not ContProfileAnswer.IsEmpty);
    end;

    local procedure FindCustomerValues(ProfileQuestionnaireLine: Record "Profile Questionnaire Line")
    var
        Cust: Record Customer;
        CustLedgEntry: Record "Cust. Ledger Entry";
        CustLedgEntry2: Record "Cust. Ledger Entry";
        ValueEntry: Record "Value Entry";
        CustContactNo: Code[20];
        NoOfInvoices: Integer;
        DaysOverdue: Integer;
        NoOfYears: Decimal;
        FromDate: Date;
        ToDate: Date;
    begin
        NoOfRecs := Cust.Count;
        if Cust.Find('-') then
          repeat
            RecCount := RecCount + 1;
            Window.Update(5,Cust."No.");
            Window.Update(6,ROUND(10000 * RecCount / NoOfRecs,1));
            CustContactNo := ContactNo(ProfileQuestionnaireLine,Database::Customer,Cust."No.");
            if CustContactNo <> '' then begin
              Cust.Reset;
              FromDate := CalcDate(ProfileQuestionnaireLine."Starting Date Formula",Date);
              ToDate := CalcDate(ProfileQuestionnaireLine."Ending Date Formula",Date);
              if ToDate < FromDate then
                ProfileQuestionnaireLine.FieldError("Ending Date Formula",
                  StrSubstNo(Text003,
                    ProfileQuestionnaireLine.FieldCaption("Ending Date Formula"),
                    ProfileQuestionnaireLine.FieldCaption("Starting Date Formula")));
              Cust.SetRange("Date Filter",FromDate,ToDate);
              case ProfileQuestionnaireLine."Customer Class. Field" of
                ProfileQuestionnaireLine."customer class. field"::"Sales (LCY)":
                  begin
                    Cust.CalcFields("Sales (LCY)");
                    InsertContactValue(ProfileQuestionnaireLine,CustContactNo,Cust."Sales (LCY)",0D,0);
                  end;
                ProfileQuestionnaireLine."customer class. field"::"Profit (LCY)":
                  begin
                    Cust.CalcFields("Profit (LCY)");
                    InsertContactValue(ProfileQuestionnaireLine,CustContactNo,Cust."Profit (LCY)",0D,0);
                  end;
                ProfileQuestionnaireLine."customer class. field"::"Sales Frequency (Invoices/Year)":
                  begin
                    CustLedgEntry.SetCurrentkey("Document Type","Customer No.","Posting Date");
                    CustLedgEntry.SetRange("Document Type",CustLedgEntry."document type"::Invoice);
                    CustLedgEntry.SetRange("Customer No.",Cust."No.");
                    CustLedgEntry.SetFilter("Posting Date",Cust.GetFilter("Date Filter"));
                    NoOfInvoices := CustLedgEntry.Count;
                    NoOfYears := (ToDate - FromDate + 1) / 365;
                    InsertContactValue(ProfileQuestionnaireLine,CustContactNo,NoOfInvoices / NoOfYears,0D,0);
                  end;
                ProfileQuestionnaireLine."customer class. field"::"Avg. Invoice Amount (LCY)":
                  begin
                    CustLedgEntry.SetCurrentkey("Document Type","Customer No.","Posting Date");
                    CustLedgEntry.SetRange("Document Type",CustLedgEntry."document type"::Invoice);
                    CustLedgEntry.SetRange("Customer No.",Cust."No.");
                    CustLedgEntry.SetFilter("Posting Date",Cust.GetFilter("Date Filter"));
                    NoOfInvoices := CustLedgEntry.Count;
                    if NoOfInvoices <> 0 then begin
                      CustLedgEntry.CalcSums("Sales (LCY)");
                      InsertContactValue(ProfileQuestionnaireLine,CustContactNo,CustLedgEntry."Sales (LCY)" / NoOfInvoices,0D,0);
                    end else
                      InsertContactValue(ProfileQuestionnaireLine,CustContactNo,0,0D,0);
                  end;
                ProfileQuestionnaireLine."customer class. field"::"Discount (%)":
                  begin
                    CustLedgEntry.SetCurrentkey("Document Type","Customer No.","Posting Date");
                    CustLedgEntry.SetRange("Document Type",CustLedgEntry."document type"::Invoice);
                    CustLedgEntry.SetRange("Customer No.",Cust."No.");
                    CustLedgEntry.SetFilter("Posting Date",Cust.GetFilter("Date Filter"));
                    if CustLedgEntry.Find('-') then begin
                      CustLedgEntry.CalcSums("Sales (LCY)");
                      ValueEntry.SetCurrentkey("Source Type","Source No.","Item No.","Posting Date");
                      ValueEntry.SetRange("Source Type",ValueEntry."source type"::Customer);
                      ValueEntry.SetRange("Source No.",Cust."No.");
                      ValueEntry.SetFilter("Posting Date",Cust.GetFilter("Date Filter"));
                      ValueEntry.CalcSums("Discount Amount");
                      ValueEntry."Discount Amount" := -ValueEntry."Discount Amount";
                      if (CustLedgEntry."Sales (LCY)" + ValueEntry."Discount Amount") <> 0 then
                        InsertContactValue(
                          ProfileQuestionnaireLine,CustContactNo,
                          100 * ValueEntry."Discount Amount" /
                          (CustLedgEntry."Sales (LCY)" + ValueEntry."Discount Amount"),0D,0)
                      else
                        InsertContactValue(ProfileQuestionnaireLine,CustContactNo,0,0D,0);
                    end else
                      InsertContactValue(ProfileQuestionnaireLine,CustContactNo,0,0D,0);
                  end;
                ProfileQuestionnaireLine."customer class. field"::"Avg. Overdue (Day)":
                  begin
                    CustLedgEntry.SetCurrentkey("Document Type","Customer No.","Posting Date");
                    CustLedgEntry.SetRange("Document Type",CustLedgEntry."document type"::Invoice);
                    CustLedgEntry.SetRange("Customer No.",Cust."No.");
                    CustLedgEntry.SetFilter("Posting Date",Cust.GetFilter("Date Filter"));
                    CustLedgEntry.SetRange(Open,false);
                    NoOfInvoices := CustLedgEntry.Count;
                    if NoOfInvoices <> 0 then begin
                      DaysOverdue := 0;
                      CustLedgEntry.Find('-');
                      repeat
                        if CustLedgEntry."Closed at Date" > CustLedgEntry."Due Date" then
                          DaysOverdue := DaysOverdue + (CustLedgEntry."Closed at Date" - CustLedgEntry."Due Date")
                        else
                          if CustLedgEntry."Closed at Date" = 0D then begin
                            CustLedgEntry2.Reset;
                            CustLedgEntry2.SetCurrentkey("Closed by Entry No.");
                            CustLedgEntry2.SetRange("Document Type",CustLedgEntry2."document type"::Payment);
                            CustLedgEntry2.SetRange("Closed by Entry No.",CustLedgEntry."Entry No.");
                            if CustLedgEntry2.FindFirst and
                               (CustLedgEntry2."Closed at Date" > CustLedgEntry."Due Date")
                            then
                              DaysOverdue := DaysOverdue + (CustLedgEntry2."Closed at Date" - CustLedgEntry."Due Date");
                          end;
                      until CustLedgEntry.Next = 0;
                      InsertContactValue(ProfileQuestionnaireLine,CustContactNo,DaysOverdue / NoOfInvoices,0D,0);
                    end else
                      InsertContactValue(ProfileQuestionnaireLine,CustContactNo,0,0D,0);
                  end;
              end;
            end;
          until Cust.Next = 0
    end;

    local procedure FindVendorValues(ProfileQuestionnaireLine: Record "Profile Questionnaire Line")
    var
        Vend: Record Vendor;
        VendLedgEntry: Record "Vendor Ledger Entry";
        VendLedgEntry2: Record "Vendor Ledger Entry";
        ValueEntry: Record "Value Entry";
        VendContactNo: Code[20];
        NoOfInvoices: Integer;
        DaysOverdue: Integer;
        NoOfYears: Decimal;
        FromDate: Date;
        ToDate: Date;
    begin
        NoOfRecs := Vend.Count;
        if Vend.Find('-') then
          repeat
            RecCount := RecCount + 1;
            Window.Update(5,Vend."No.");
            Window.Update(6,ROUND(10000 * RecCount / NoOfRecs,1));
            VendContactNo := ContactNo(ProfileQuestionnaireLine,Database::Vendor,Vend."No.");
            if VendContactNo <> '' then begin
              Vend.Reset;
              FromDate := CalcDate(ProfileQuestionnaireLine."Starting Date Formula",Date);
              ToDate := CalcDate(ProfileQuestionnaireLine."Ending Date Formula",Date);
              if ToDate < FromDate then
                ProfileQuestionnaireLine.FieldError("Ending Date Formula",
                  StrSubstNo(Text003,
                    ProfileQuestionnaireLine.FieldCaption("Ending Date Formula"),
                    ProfileQuestionnaireLine.FieldCaption("Starting Date Formula")));
              Vend.SetRange("Date Filter",FromDate,ToDate);
              case ProfileQuestionnaireLine."Vendor Class. Field" of
                ProfileQuestionnaireLine."vendor class. field"::"Purchase (LCY)":
                  begin
                    Vend.CalcFields("Purchases (LCY)");
                    Vend."Purchases (LCY)" := Vend."Purchases (LCY)";
                    InsertContactValue(ProfileQuestionnaireLine,VendContactNo,Vend."Purchases (LCY)",0D,0);
                  end;
                ProfileQuestionnaireLine."vendor class. field"::"Purchase Frequency (Invoices/Year)":
                  begin
                    VendLedgEntry.SetCurrentkey("Document Type","Vendor No.","Posting Date");
                    VendLedgEntry.SetRange("Document Type",VendLedgEntry."document type"::Invoice);
                    VendLedgEntry.SetRange("Vendor No.",Vend."No.");
                    VendLedgEntry.SetFilter("Posting Date",Vend.GetFilter("Date Filter"));
                    NoOfInvoices := VendLedgEntry.Count;
                    NoOfYears := (ToDate - FromDate + 1) / 365;
                    InsertContactValue(ProfileQuestionnaireLine,VendContactNo,NoOfInvoices / NoOfYears,0D,0);
                  end;
                ProfileQuestionnaireLine."vendor class. field"::"Avg. Ticket Size (LCY)":
                  begin
                    VendLedgEntry.SetCurrentkey("Document Type","Vendor No.","Posting Date");
                    VendLedgEntry.SetRange("Document Type",VendLedgEntry."document type"::Invoice);
                    VendLedgEntry.SetRange("Vendor No.",Vend."No.");
                    VendLedgEntry.SetFilter("Posting Date",Vend.GetFilter("Date Filter"));
                    NoOfInvoices := VendLedgEntry.Count;
                    if NoOfInvoices <> 0 then begin
                      VendLedgEntry.CalcSums("Purchase (LCY)");
                      VendLedgEntry."Purchase (LCY)" := -VendLedgEntry."Purchase (LCY)";
                      InsertContactValue(ProfileQuestionnaireLine,VendContactNo,VendLedgEntry."Purchase (LCY)" / NoOfInvoices,0D,0);
                    end else
                      InsertContactValue(ProfileQuestionnaireLine,VendContactNo,0,0D,0);
                  end;
                ProfileQuestionnaireLine."vendor class. field"::"Discount (%)":
                  begin
                    VendLedgEntry.SetCurrentkey("Document Type","Vendor No.","Posting Date");
                    VendLedgEntry.SetRange("Document Type",VendLedgEntry."document type"::Invoice);
                    VendLedgEntry.SetRange("Vendor No.",Vend."No.");
                    VendLedgEntry.SetFilter("Posting Date",Vend.GetFilter("Date Filter"));
                    if VendLedgEntry.Find('-') then begin
                      VendLedgEntry.CalcSums("Purchase (LCY)");
                      VendLedgEntry."Purchase (LCY)" := -VendLedgEntry."Purchase (LCY)";
                      ValueEntry.SetCurrentkey("Source Type","Source No.","Item No.","Posting Date");
                      ValueEntry.SetRange("Source Type",ValueEntry."source type"::Vendor);
                      ValueEntry.SetRange("Source No.",Vend."No.");
                      ValueEntry.SetFilter("Posting Date",Vend.GetFilter("Date Filter"));
                      ValueEntry.CalcSums("Discount Amount");
                      if (VendLedgEntry."Purchase (LCY)" + ValueEntry."Discount Amount") <> 0 then
                        InsertContactValue(
                          ProfileQuestionnaireLine,VendContactNo,
                          100 * ValueEntry."Discount Amount" /
                          (VendLedgEntry."Purchase (LCY)" + ValueEntry."Discount Amount"),0D,0)
                      else
                        InsertContactValue(ProfileQuestionnaireLine,VendContactNo,0,0D,0);
                    end else
                      InsertContactValue(ProfileQuestionnaireLine,VendContactNo,0,0D,0);
                  end;
                ProfileQuestionnaireLine."vendor class. field"::"Avg. Overdue (Day)":
                  begin
                    VendLedgEntry.SetCurrentkey("Document Type","Vendor No.","Posting Date");
                    VendLedgEntry.SetRange("Document Type",VendLedgEntry."document type"::Invoice);
                    VendLedgEntry.SetRange("Vendor No.",Vend."No.");
                    VendLedgEntry.SetFilter("Posting Date",Vend.GetFilter("Date Filter"));
                    VendLedgEntry.SetRange(Open,false);
                    NoOfInvoices := VendLedgEntry.Count;
                    if NoOfInvoices <> 0 then begin
                      DaysOverdue := 0;
                      VendLedgEntry.Find('-');
                      repeat
                        if VendLedgEntry."Closed at Date" > VendLedgEntry."Due Date" then
                          DaysOverdue := DaysOverdue + (VendLedgEntry."Closed at Date" - VendLedgEntry."Due Date")
                        else
                          if VendLedgEntry."Closed at Date" = 0D then begin
                            VendLedgEntry2.Reset;
                            VendLedgEntry2.SetCurrentkey("Closed by Entry No.");
                            VendLedgEntry2.SetRange("Document Type",VendLedgEntry2."document type"::Payment);
                            VendLedgEntry2.SetRange("Closed by Entry No.",VendLedgEntry."Entry No.");
                            if VendLedgEntry2.FindFirst and
                               (VendLedgEntry2."Closed at Date" > VendLedgEntry."Due Date")
                            then
                              DaysOverdue := DaysOverdue + (VendLedgEntry2."Closed at Date" - VendLedgEntry."Due Date");
                          end;
                      until VendLedgEntry.Next = 0;
                      InsertContactValue(ProfileQuestionnaireLine,VendContactNo,DaysOverdue / NoOfInvoices,0D,0);
                    end else
                      InsertContactValue(ProfileQuestionnaireLine,VendContactNo,0,0D,0);
                  end;
              end;
            end;
          until Vend.Next = 0
    end;

    local procedure FindContactValues(ProfileQuestionnaireLine: Record "Profile Questionnaire Line")
    var
        Cont: Record Contact;
        ContNo: Code[20];
        NoOfYears: Decimal;
        WonCount: Integer;
        LostCount: Integer;
        FromDate: Date;
        ToDate: Date;
    begin
        NoOfRecs := Cont.Count;
        if Cont.Find('-') then
          repeat
            RecCount := RecCount + 1;
            Window.Update(5,Cont."No.");
            Window.Update(6,ROUND(10000 * RecCount / NoOfRecs,1));
            ContNo := ContactNo(ProfileQuestionnaireLine,Database::Contact,Cont."No.");
            if ContNo <> '' then begin
              Cont.Reset;
              FromDate := CalcDate(ProfileQuestionnaireLine."Starting Date Formula",Date);
              ToDate := CalcDate(ProfileQuestionnaireLine."Ending Date Formula",Date);
              if ToDate < FromDate then
                ProfileQuestionnaireLine.FieldError("Ending Date Formula",
                  StrSubstNo(Text003,
                    ProfileQuestionnaireLine.FieldCaption("Ending Date Formula"),
                    ProfileQuestionnaireLine.FieldCaption("Starting Date Formula")));
              Cont.SetRange("Date Filter",FromDate,ToDate);
              case ProfileQuestionnaireLine."Contact Class. Field" of
                ProfileQuestionnaireLine."contact class. field"::"Interaction Quantity":
                  begin
                    Cont.CalcFields("No. of Interactions");
                    InsertContactValue(ProfileQuestionnaireLine,Cont."No.",Cont."No. of Interactions",0D,0);
                  end;
                ProfileQuestionnaireLine."contact class. field"::"Interaction Frequency (No./Year)":
                  begin
                    Cont.CalcFields("No. of Interactions");
                    NoOfYears := (ToDate - FromDate + 1) / 365;
                    InsertContactValue(ProfileQuestionnaireLine,Cont."No.",Cont."No. of Interactions" / NoOfYears,0D,0);
                  end;
                ProfileQuestionnaireLine."contact class. field"::"Avg. Interaction Cost (LCY)":
                  begin
                    Cont.CalcFields("No. of Interactions","Cost (LCY)");
                    if Cont."No. of Interactions" <> 0 then
                      InsertContactValue(ProfileQuestionnaireLine,Cont."No.",Cont."Cost (LCY)" / Cont."No. of Interactions",0D,0)
                    else
                      InsertContactValue(ProfileQuestionnaireLine,Cont."No.",0,0D,0);
                  end;
                ProfileQuestionnaireLine."contact class. field"::"Avg. Interaction Duration (Min.)":
                  begin
                    Cont.CalcFields("No. of Interactions","Duration (Min.)");
                    if Cont."No. of Interactions" <> 0 then
                      InsertContactValue(ProfileQuestionnaireLine,Cont."No.",Cont."Duration (Min.)" / Cont."No. of Interactions",0D,0)
                    else
                      InsertContactValue(ProfileQuestionnaireLine,Cont."No.",0,0D,0);
                  end;
                ProfileQuestionnaireLine."contact class. field"::"Opportunity Won (%)":
                  begin
                    Cont.SetRange("Action Taken Filter",Cont."action taken filter"::Won);
                    Cont.CalcFields("No. of Opportunities");
                    WonCount := Cont."No. of Opportunities";
                    Cont.SetRange("Action Taken Filter",Cont."action taken filter"::Lost);
                    Cont.CalcFields("No. of Opportunities");
                    LostCount := Cont."No. of Opportunities";
                    if (LostCount + WonCount) <> 0 then
                      InsertContactValue(ProfileQuestionnaireLine,Cont."No.",100 * WonCount / (LostCount + WonCount),0D,0)
                    else
                      InsertContactValue(ProfileQuestionnaireLine,Cont."No.",0,0D,0);
                  end;
              end;
            end;
          until Cont.Next = 0
    end;

    local procedure ContactNo(ProfileQuestionnaireLine: Record "Profile Questionnaire Line";TableID: Integer;No: Code[20]) ContactNo: Code[20]
    var
        ContBusRel: Record "Contact Business Relation";
        Cont: Record Contact;
        ProfileQuestnHeader: Record "Profile Questionnaire Header";
    begin
        ProfileQuestnHeader.Get(ProfileQuestionnaireLine."Profile Questionnaire Code");
        if TableID = Database::Contact then
          ContactNo := No
        else
          with ContBusRel do begin
            Reset;
            SetCurrentkey("Link to Table","No.");
            case TableID of
              Database::Customer:
                SetRange("Link to Table","link to table"::Customer);
              Database::Vendor:
                SetRange("Link to Table","link to table"::Vendor);
            end;
            SetRange("No.",No);
            if FindFirst then
              ContactNo := "Contact No."
            else
              exit('');
          end;

        Cont.Get(ContactNo);
        if (ProfileQuestnHeader."Contact Type" = ProfileQuestnHeader."contact type"::Companies) and
           (Cont.Type <> Cont.Type::Company)
        then
          exit('');

        if ProfileQuestnHeader."Business Relation Code" = '' then
          exit(ContactNo);

        ContBusRel.Reset;
        if TableID = Database::Contact then
          ContBusRel.SetRange("Contact No.",Cont."Company No.")
        else
          ContBusRel.SetRange("Contact No.",ContactNo);
        ContBusRel.SetRange("Business Relation Code",ProfileQuestnHeader."Business Relation Code");
        if not ContBusRel.IsEmpty then
          exit(ContactNo);
        ContactNo := '';
    end;

    local procedure InsertContactValue(ProfileQuestionnaireLine: Record "Profile Questionnaire Line";ContactNo: Code[20];Value: Decimal;UpdateDate: Date;QuestionsAnsweredPrc: Decimal)
    begin
        ContactValue.Init;
        ContactValue."Contact No." := ContactNo;
        if ProfileQuestionnaireLine."Classification Method" = ProfileQuestionnaireLine."classification method"::"Defined Value" then
          ContactValue.Value := ROUND(Value,1 / Power(10,ProfileQuestionnaireLine."No. of Decimals"))
        else
          ContactValue.Value := Value;
        ContactValue."Last Date Updated" := UpdateDate;
        ContactValue."Questions Answered (%)" := QuestionsAnsweredPrc;
        ContactValue.Insert;
        TotalValue := TotalValue + ContactValue.Value;
    end;

    local procedure MarkByDefinedValue(ProfileQuestnLineQuestion: Record "Profile Questionnaire Line";ProfileQuestnLineAnswer: Record "Profile Questionnaire Line")
    begin
        ContactValue.Reset;
        if ContactValue.Find('-') then
          repeat
            if InRange(ContactValue.Value,ProfileQuestnLineAnswer."From Value",ProfileQuestnLineAnswer."To Value") then
              MarkContact(
                ProfileQuestnLineQuestion,ProfileQuestnLineAnswer,ContactValue."Contact No.",
                ContactValue."Last Date Updated",ContactValue."Questions Answered (%)")
          until ContactValue.Next = 0;
    end;

    local procedure MarkByPercentageOfValue(ProfileQuestnLineQuestion: Record "Profile Questionnaire Line";ProfileQuestnLineAnswer: Record "Profile Questionnaire Line")
    var
        AccAmount: Decimal;
        Prc: Decimal;
    begin
        ContactValue.Reset;
        ContactValue.SetCurrentkey(Value);

        if ProfileQuestnLineQuestion."Sorting Method" = ProfileQuestnLineQuestion."sorting method"::" " then
          Error(
            Text008,
            ProfileQuestnLineQuestion.FieldCaption("Sorting Method"),
            ProfileQuestnLineQuestion."Profile Questionnaire Code",
            ProfileQuestnLineQuestion.Description);

        case ProfileQuestnLineQuestion."Sorting Method" of
          ProfileQuestnLineQuestion."sorting method"::Descending:
            ContactValue.Ascending(false);
          ProfileQuestnLineQuestion."sorting method"::Ascending:
            ContactValue.Ascending(true);
        end;

        if ContactValue.Find('-') then begin
          AccAmount := 0;
          repeat
            AccAmount := AccAmount + ContactValue.Value;
            if TotalValue <> 0 then
              Prc := ROUND(100 * AccAmount / TotalValue,1 / Power(10,ProfileQuestnLineQuestion."No. of Decimals"))
            else
              Prc := 0;
            if InRange(Prc,ProfileQuestnLineAnswer."From Value",ProfileQuestnLineAnswer."To Value") then
              MarkContact(
                ProfileQuestnLineQuestion,ProfileQuestnLineAnswer,ContactValue."Contact No.",
                ContactValue."Last Date Updated",ContactValue."Questions Answered (%)");
          until ContactValue.Next = 0
        end;
    end;

    local procedure MarkByPercentageOfContacts(ProfileQuestnLineQuestion: Record "Profile Questionnaire Line";ProfileQuestnLineAnswer: Record "Profile Questionnaire Line")
    var
        ContactValueCount: Integer;
        RecNo: Integer;
        Prc: Decimal;
    begin
        ContactValue.Reset;
        ContactValue.SetCurrentkey(Value);

        if ProfileQuestnLineQuestion."Sorting Method" = ProfileQuestnLineQuestion."sorting method"::" " then
          Error(
            Text008,
            ProfileQuestnLineQuestion.FieldCaption("Sorting Method"),
            ProfileQuestnLineQuestion."Profile Questionnaire Code",
            ProfileQuestnLineQuestion.Description);

        case ProfileQuestnLineQuestion."Sorting Method" of
          ProfileQuestnLineQuestion."sorting method"::Descending:
            ContactValue.Ascending(false);
          ProfileQuestnLineQuestion."sorting method"::Ascending:
            ContactValue.Ascending(true);
        end;

        if ContactValue.Find('-') then begin
          ContactValueCount := ContactValue.Count;
          RecNo := 0;
          repeat
            RecNo := RecNo + 1;
            Prc := ROUND(100 * RecNo / ContactValueCount,1 / Power(10,ProfileQuestnLineQuestion."No. of Decimals"));
            if InRange(Prc,ProfileQuestnLineAnswer."From Value",ProfileQuestnLineAnswer."To Value") then
              MarkContact(
                ProfileQuestnLineQuestion,ProfileQuestnLineAnswer,ContactValue."Contact No.",
                ContactValue."Last Date Updated",ContactValue."Questions Answered (%)")
          until ContactValue.Next = 0
        end;
    end;

    local procedure InRange(Value: Decimal;FromValue: Decimal;ToValue: Decimal): Boolean
    begin
        if (FromValue <> 0) and (ToValue <> 0) and (Value >= FromValue) and (Value <= ToValue) then
          exit(true);
        if (FromValue <> 0) and (ToValue = 0) and (Value >= FromValue) then
          exit(true);
        if (FromValue = 0) and (ToValue <> 0) and (Value <= ToValue) then
          exit(true);
    end;

    local procedure MarkContact(ProfileQuestnLineQuestion: Record "Profile Questionnaire Line";ProfileQuestnLineAnswer: Record "Profile Questionnaire Line";ContNo: Code[20];UpdateDate: Date;QuestionsAnsweredPrc: Decimal)
    var
        Cont: Record Contact;
        ContPers: Record Contact;
        ContProfileAnswer: Record "Contact Profile Answer";
        ProfileQuestnHeader2: Record "Profile Questionnaire Header";
    begin
        ProfileQuestnHeader2.Get(ProfileQuestnLineQuestion."Profile Questionnaire Code");

        Cont.Get(ContNo);
        if (Cont.Type = Cont.Type::Company) and
           (ProfileQuestnLineQuestion."Contact Class. Field" = ProfileQuestnLineQuestion."contact class. field"::" ") and
           (ProfileQuestnHeader2."Contact Type" <> ProfileQuestnHeader2."contact type"::Companies)
        then begin
          ContPers.Reset;
          ContPers.SetCurrentkey("Company No.");
          ContPers.SetRange("Company No.",Cont."No.");
          ContPers.SetRange(Type,Cont.Type::Person);
          if ContPers.Find('-') then
            repeat
              MarkContact(ProfileQuestnLineQuestion,ProfileQuestnLineAnswer,ContPers."No.",UpdateDate,QuestionsAnsweredPrc);
            until ContPers.Next = 0
        end;

        if (ProfileQuestnHeader2."Contact Type" = ProfileQuestnHeader2."contact type"::People) and
           (Cont.Type <> Cont.Type::Person)
        then
          exit;
        if (ProfileQuestnHeader2."Contact Type" = ProfileQuestnHeader2."contact type"::Companies) and
           (Cont.Type <> Cont.Type::Company)
        then
          exit;

        ContProfileAnswer.Init;
        ContProfileAnswer."Contact No." := Cont."No.";
        ContProfileAnswer."Profile Questionnaire Code" := ProfileQuestnLineAnswer."Profile Questionnaire Code";
        ContProfileAnswer."Line No." := ProfileQuestnLineAnswer."Line No.";
        ContProfileAnswer."Contact Company No." := Cont."Company No.";
        ContProfileAnswer."Profile Questionnaire Priority" := ProfileQuestnHeader2.Priority;
        ContProfileAnswer."Answer Priority" := ProfileQuestnLineAnswer.Priority;
        ContProfileAnswer."Questions Answered (%)" := QuestionsAnsweredPrc;
        if UpdateDate = 0D then
          ContProfileAnswer."Last Date Updated" := Today
        else
          ContProfileAnswer."Last Date Updated" := UpdateDate;
        ContProfileAnswer.Insert;
    end;


    procedure UpdateRating(UpdateContNo: Code[20])
    var
        ProfileQuestnLine: Record "Profile Questionnaire Line";
        ProfileQuestnLine2: Record "Profile Questionnaire Line";
        Rating: Record Rating;
        RatingQuestion: Record Rating;
        Cont: Record Contact;
        Leaf: Boolean;
        Changed: Boolean;
        ContNo: Code[20];
        NoOfRatingLines: Integer;
        RatingLineNo: Integer;
        Points: Integer;
        UpdateDate: Date;
        QuestionsAnsweredPrc: Decimal;
    begin
        // Mark all non-calculated rating questions
        ProfileQuestnLine.Reset;
        ProfileQuestnLine.SetRange("Contact Class. Field",ProfileQuestnLine."contact class. field"::Rating);
        if "Profile Questionnaire Header".Code <> '' then
          ProfileQuestnLine.SetRange("Profile Questionnaire Code","Profile Questionnaire Header".Code);
        if not ProfileQuestnLine.Find('-') then
          exit;
        repeat
          ProfileQuestnLine.Mark(true);
          NoOfRatingLines := NoOfRatingLines + 1;
        until ProfileQuestnLine.Next = 0;
        ProfileQuestnLine.MarkedOnly(true);

        // Calculate Ratings
        repeat
          Changed := false;
          if ProfileQuestnLine.Find('-') then
            repeat
              Leaf := true;
              Rating.SetRange("Profile Questionnaire Code",ProfileQuestnLine."Profile Questionnaire Code");
              Rating.SetRange("Profile Questionnaire Line No.",ProfileQuestnLine."Line No.");
              if Rating.Find('-') then
                repeat
                  ProfileQuestnLine2.Get(Rating."Rating Profile Quest. Code",Rating."Rating Profile Quest. Line No.");
                  RatingQuestion.SetRange("Profile Questionnaire Code",Rating."Rating Profile Quest. Code");
                  RatingQuestion.SetRange("Profile Questionnaire Line No.",ProfileQuestnLine2.FindQuestionLine);
                  if RatingQuestion.FindFirst then begin
                    ProfileQuestnLine2 := ProfileQuestnLine;
                    ProfileQuestnLine.Get(
                      RatingQuestion."Profile Questionnaire Code",RatingQuestion."Profile Questionnaire Line No.");
                    if ProfileQuestnLine.Mark then
                      Leaf := false;
                    ProfileQuestnLine := ProfileQuestnLine2;
                  end;
                until (Rating.Next = 0) or (not Leaf);

              // Calculate Rating
              if Leaf then begin
                if UpdateContNo = '' then begin
                  RatingLineNo := RatingLineNo + 1;
                  Window.Update(1,ProfileQuestnLine."Profile Questionnaire Code");
                  Window.Update(3,ProfileQuestnLine."Line No.");
                  Window.Update(4,ROUND(10000 * RatingLineNo / NoOfRatingLines,1));
                  NoOfRecs := Cont.Count;
                  RecCount := 0;
                  TotalValue := 0;
                end;
                ContactValue.DeleteAll;
                AnswersExists(ProfileQuestnLine,UpdateContNo,true);
                if UpdateContNo <> '' then
                  Cont.SetRange("No.",UpdateContNo);
                if Cont.Find('-') then
                  repeat
                    if UpdateContNo = '' then begin
                      RecCount := RecCount + 1;
                      Window.Update(5,Cont."No.");
                      Window.Update(6,ROUND(10000 * RecCount / NoOfRecs,1));
                    end;
                    ContNo := ContactNo(ProfileQuestnLine,Database::Contact,Cont."No.");
                    if ContNo <> '' then begin
                      Points := FindContactRatingValue(ProfileQuestnLine,Cont,UpdateDate,QuestionsAnsweredPrc);
                      if QuestionsAnsweredPrc >= ProfileQuestnLine."Min. % Questions Answered" then
                        InsertContactValue(ProfileQuestnLine,Cont."No.",Points,UpdateDate,QuestionsAnsweredPrc);
                    end;
                  until Cont.Next = 0;
                MarkContactByMethod(ProfileQuestnLine,UpdateContNo);
                ProfileQuestnLine.Mark(false);
                Changed := true;
              end;
            until ProfileQuestnLine.Next = 0;
        until Changed = false;

        if ProfileQuestnLine.Find('-') then
          Error(Text004);
    end;

    local procedure FindContactRatingValue(ProfileQuestnLine: Record "Profile Questionnaire Line";Cont: Record Contact;var UpdateDate: Date;var QuestionsAnsweredPrc: Decimal) Value: Decimal
    var
        Rating: Record Rating;
        ContProfileAnswer: Record "Contact Profile Answer";
        ProfileQuestionnaireLine: Record "Profile Questionnaire Line";
        TempProfileQuestnLine: Record "Profile Questionnaire Line" temporary;
        NoOfAnsweredQuestions: Integer;
    begin
        UpdateDate := Today;
        Rating.SetRange("Profile Questionnaire Code",ProfileQuestnLine."Profile Questionnaire Code");
        Rating.SetRange("Profile Questionnaire Line No.",ProfileQuestnLine."Line No.");
        if Rating.Find('-') then
          repeat
            ProfileQuestionnaireLine.Get(Rating."Rating Profile Quest. Code",Rating."Rating Profile Quest. Line No.");
            ProfileQuestionnaireLine.Get(
              ProfileQuestionnaireLine."Profile Questionnaire Code",ProfileQuestionnaireLine.FindQuestionLine);
            if not TempProfileQuestnLine.Get(
                 ProfileQuestionnaireLine."Profile Questionnaire Code",ProfileQuestionnaireLine."Line No.")
            then begin
              TempProfileQuestnLine.Init;
              TempProfileQuestnLine."Profile Questionnaire Code" := ProfileQuestionnaireLine."Profile Questionnaire Code";
              TempProfileQuestnLine."Line No." := ProfileQuestionnaireLine."Line No.";
              TempProfileQuestnLine.Insert;
              if AnswersExists(ProfileQuestionnaireLine,Cont."No.",false) then
                NoOfAnsweredQuestions := NoOfAnsweredQuestions + 1;
            end;

            if ContProfileAnswer.Get(
                 Cont."No.",Rating."Rating Profile Quest. Code",Rating."Rating Profile Quest. Line No.")
            then begin
              Value := Value + Rating.Points;
              if ContProfileAnswer."Last Date Updated" < UpdateDate then
                UpdateDate := ContProfileAnswer."Last Date Updated";
            end;
          until Rating.Next = 0;

        if TempProfileQuestnLine.Count <> 0 then
          QuestionsAnsweredPrc := NoOfAnsweredQuestions / TempProfileQuestnLine.Count * 100
        else
          QuestionsAnsweredPrc := 0;
    end;

    local procedure MarkContactByMethod(ProfileQuestnLine: Record "Profile Questionnaire Line";UpdateContNo: Code[20])
    var
        ProfileQuestnLine2: Record "Profile Questionnaire Line";
    begin
        ProfileQuestnLine2.Reset;
        ProfileQuestnLine2 := ProfileQuestnLine;
        ProfileQuestnLine2.SetRange("Profile Questionnaire Code",ProfileQuestnLine."Profile Questionnaire Code");
        if ProfileQuestnLine2.Find('>') and
           (ProfileQuestnLine2.Type = ProfileQuestnLine2.Type::Answer)
        then
          repeat
            if UpdateContNo = '' then
              Window.Update(3,ProfileQuestnLine2."Line No.");
            case ProfileQuestnLine."Classification Method" of
              ProfileQuestnLine."classification method"::"Defined Value":
                MarkByDefinedValue(ProfileQuestnLine,ProfileQuestnLine2);
              ProfileQuestnLine."classification method"::"Percentage of Value":
                MarkByPercentageOfValue(ProfileQuestnLine,ProfileQuestnLine2);
              ProfileQuestnLine."classification method"::"Percentage of Contacts":
                MarkByPercentageOfContacts(ProfileQuestnLine,ProfileQuestnLine2);
            end;
          until (ProfileQuestnLine2.Next = 0) or
                (ProfileQuestnLine2.Type = ProfileQuestnLine2.Type::Question);
    end;
}

