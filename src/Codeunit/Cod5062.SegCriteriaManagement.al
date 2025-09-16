#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5062 SegCriteriaManagement
{

    trigger OnRun()
    begin
    end;


    procedure InsertContact(SegmentNo: Code[20];ContactNo: Code[20])
    var
        Cont: Record Contact;
    begin
        Cont.SetRange("No.",ContactNo);

        InsertCriteriaAction(SegmentNo,Report::"Add Contacts",false,false,false,false,false);
        InsertCriteriaFilter(SegmentNo,Database::Contact,Cont.GetFilters,Cont.GetView(false));
    end;


    procedure DeleteContact(SegmentNo: Code[20];ContactNo: Code[20])
    var
        Cont: Record Contact;
    begin
        Cont.SetRange("No.",ContactNo);

        InsertCriteriaAction(SegmentNo,Report::"Remove Contacts - Reduce",false,false,false,false,false);
        InsertCriteriaFilter(SegmentNo,Database::Contact,Cont.GetFilters,Cont.GetView(false));
    end;


    procedure InsertReuseLogged(SegmentNo: Code[20];LoggedSegmentEntryNo: Integer)
    var
        InteractLogEntry: Record "Interaction Log Entry";
    begin
        InteractLogEntry.SetCurrentkey("Logged Segment Entry No.");
        InteractLogEntry.SetRange("Logged Segment Entry No.",LoggedSegmentEntryNo);

        InsertCriteriaAction(SegmentNo,Report::"Add Contacts",true,false,false,false,false);
        InsertCriteriaFilter(
          SegmentNo,Database::"Interaction Log Entry",InteractLogEntry.GetFilters,InteractLogEntry.GetView(false));
    end;


    procedure InsertCriteriaAction(SegmentNo: Code[20];CalledFromReportNo: Integer;AllowExistingContacts: Boolean;ExpandContact: Boolean;AllowCompanyWithPersons: Boolean;IgnoreExclusion: Boolean;EntireCompanies: Boolean)
    var
        SegCriteriaLine: Record "Segment Criteria Line";
        NextLineNo: Integer;
    begin
        SegCriteriaLine.LockTable;
        SegCriteriaLine.SetRange("Segment No.",SegmentNo);
        if SegCriteriaLine.FindLast then
          NextLineNo := SegCriteriaLine."Line No." + 1
        else
          NextLineNo := 1;

        SegCriteriaLine.Init;
        SegCriteriaLine."Segment No." := SegmentNo;
        SegCriteriaLine."Line No." := NextLineNo;
        SegCriteriaLine.Type := SegCriteriaLine.Type::Action;
        case CalledFromReportNo of
          Report::"Add Contacts":
            SegCriteriaLine.Action := SegCriteriaLine.Action::"Add Contacts";
          Report::"Remove Contacts - Reduce":
            SegCriteriaLine.Action := SegCriteriaLine.Action::"Remove Contacts (Reduce)";
          Report::"Remove Contacts - Refine":
            SegCriteriaLine.Action := SegCriteriaLine.Action::"Remove Contacts (Refine)";
        end;
        SegCriteriaLine."Allow Existing Contacts" := AllowExistingContacts;
        SegCriteriaLine."Expand Contact" := ExpandContact;
        SegCriteriaLine."Allow Company with Persons" := AllowCompanyWithPersons;
        SegCriteriaLine."Ignore Exclusion" := IgnoreExclusion;
        SegCriteriaLine."Entire Companies" := EntireCompanies;
        SegCriteriaLine.Insert;
    end;


    procedure InsertCriteriaFilter(SegmentNo: Code[20];TableNo: Integer;"Filter": Text[250];View: Text[250])
    var
        SegCriteriaLine: Record "Segment Criteria Line";
        NextLineNo: Integer;
    begin
        if Filter = '' then
          exit;

        SegCriteriaLine.SetRange("Segment No.",SegmentNo);
        if SegCriteriaLine.FindLast then
          NextLineNo := SegCriteriaLine."Line No." + 1
        else
          NextLineNo := 1;

        SegCriteriaLine.Init;
        SegCriteriaLine."Segment No." := SegmentNo;
        SegCriteriaLine."Line No." := NextLineNo;
        SegCriteriaLine.Type := SegCriteriaLine.Type::Filter;
        SegCriteriaLine."Table No." := TableNo;
        SegCriteriaLine.View := View;
        SegCriteriaLine.Insert;

        SegCriteriaLine.Reset;
        SegCriteriaLine.SetCurrentkey("Segment No.",Type);
        SegCriteriaLine.SetRange("Segment No.",SegmentNo);
        SegCriteriaLine.SetRange(Type,SegCriteriaLine.Type::Action);
        SegCriteriaLine.FindLast;
        SegCriteriaLine."No. of Filters" := SegCriteriaLine."No. of Filters" + 1;
        SegCriteriaLine.Modify;
    end;


    procedure SegCriteriaFilter(TableNo: Integer;View: Text[250]): Text[250]
    var
        Cont: Record Contact;
        ContProfileAnswer: Record "Contact Profile Answer";
        ContMailingGrp: Record "Contact Mailing Group";
        InteractLogEntry: Record "Interaction Log Entry";
        ContJobResp: Record "Contact Job Responsibility";
        ContIndustGrp: Record "Contact Industry Group";
        ContBusRel: Record "Contact Business Relation";
        ValueEntry: Record "Value Entry";
        ProfileQuestionnaireLine: Record "Profile Questionnaire Line";
    begin
        case TableNo of
          Database::Contact:
            begin
              Cont.SetView(View);
              exit(Cont.GetFilters);
            end;
          Database::"Contact Profile Answer":
            begin
              ContProfileAnswer.SetView(View);
              ContProfileAnswer.Copyfilter(
                "Profile Questionnaire Code",ProfileQuestionnaireLine."Profile Questionnaire Code");
              ContProfileAnswer.Copyfilter("Line No.",ProfileQuestionnaireLine."Line No.");
              if ProfileQuestionnaireLine.Count = 1 then begin
                ProfileQuestionnaireLine.FindFirst;
                exit(SelectStr(1,ContProfileAnswer.GetFilters) + ', ' +
                  ProfileQuestionnaireLine.Question + ': ' + ProfileQuestionnaireLine.Description);
              end;
              exit(ContProfileAnswer.GetFilters);
            end;
          Database::"Contact Mailing Group":
            begin
              ContMailingGrp.SetView(View);
              exit(ContMailingGrp.GetFilters);
            end;
          Database::"Interaction Log Entry":
            begin
              InteractLogEntry.SetView(View);
              exit(InteractLogEntry.GetFilters);
            end;
          Database::"Contact Job Responsibility":
            begin
              ContJobResp.SetView(View);
              exit(ContJobResp.GetFilters);
            end;
          Database::"Contact Industry Group":
            begin
              ContIndustGrp.SetView(View);
              exit(ContIndustGrp.GetFilters);
            end;
          Database::"Contact Business Relation":
            begin
              ContBusRel.SetView(View);
              exit(ContBusRel.GetFilters);
            end;
          Database::"Value Entry":
            begin
              ValueEntry.SetView(View);
              exit(ValueEntry.GetFilters);
            end;
        end;
    end;
}

