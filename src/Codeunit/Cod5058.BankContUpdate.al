#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5058 "BankCont-Update"
{

    trigger OnRun()
    begin
    end;

    var
        RMSetup: Record "Marketing Setup";


    procedure OnInsert(var BankAcc: Record "Bank Account")
    begin
        RMSetup.Get;
        if RMSetup."Bus. Rel. Code for Bank Accs." = '' then
          exit;

        InsertNewContact(BankAcc,true);
    end;


    procedure OnModify(var BankAcc: Record "Bank Account")
    var
        Cont: Record Contact;
        OldCont: Record Contact;
        ContBusRel: Record "Contact Business Relation";
        ContNo: Code[20];
        NoSeries: Code[10];
        SalespersonCode: Code[10];
    begin
        with ContBusRel do begin
          SetCurrentkey("Link to Table","No.");
          SetRange("Link to Table","link to table"::"Bank Account");
          SetRange("No.",BankAcc."No.");
          if not FindFirst then
            exit;
          Cont.Get("Contact No.");
          OldCont := Cont;
        end;

        ContNo := Cont."No.";
        NoSeries := Cont."No. Series";
        SalespersonCode := Cont."Salesperson Code";
        Cont.Validate("E-Mail",BankAcc."E-Mail");
        Cont.TransferFields(BankAcc);
        Cont."No." := ContNo ;
        Cont."No. Series" := NoSeries;
        Cont."Salesperson Code" := SalespersonCode;
        Cont.Validate(Name);
        Cont.OnModify(OldCont);
        Cont.Modify(true);
    end;


    procedure OnDelete(var BankAcc: Record "Bank Account")
    var
        ContBusRel: Record "Contact Business Relation";
    begin
        with ContBusRel do begin
          SetCurrentkey("Link to Table","No.");
          SetRange("Link to Table","link to table"::"Bank Account");
          SetRange("No.",BankAcc."No.");
          DeleteAll(true);
        end;
    end;


    procedure InsertNewContact(var BankAcc: Record "Bank Account";LocalCall: Boolean)
    var
        Cont: Record Contact;
        ContBusRel: Record "Contact Business Relation";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if not LocalCall then begin
          RMSetup.Get;
          RMSetup.TestField("Bus. Rel. Code for Bank Accs.");
        end;

        with Cont do begin
          Init;
          TransferFields(BankAcc);
          Validate(Name);
          Validate("E-Mail");
          "No." := '';
          "No. Series" := '';
          RMSetup.TestField("Contact Nos.");
          NoSeriesMgt.InitSeries(RMSetup."Contact Nos.",'',0D,"No.","No. Series");
          Type := Type::Company;
          TypeChange;
          SetSkipDefault;
          Insert(true);
        end;

        with ContBusRel do begin
          Init;
          "Contact No." := Cont."No.";
          "Business Relation Code" := RMSetup."Bus. Rel. Code for Bank Accs.";
          "Link to Table" := "link to table"::"Bank Account";
          "No." := BankAcc."No.";
          Insert(true);
        end;
    end;
}

