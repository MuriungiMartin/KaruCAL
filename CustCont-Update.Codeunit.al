#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5056 "CustCont-Update"
{

    trigger OnRun()
    begin
    end;

    var
        RMSetup: Record "Marketing Setup";


    procedure OnInsert(var Cust: Record Customer)
    begin
        RMSetup.Get;
        if RMSetup."Bus. Rel. Code for Customers" = '' then
          exit;

        InsertNewContact(Cust,true);
    end;


    procedure OnModify(var Cust: Record Customer)
    var
        ContBusRel: Record "Contact Business Relation";
        Cont: Record Contact;
        OldCont: Record Contact;
        ContNo: Code[20];
        NoSeries: Code[10];
    begin
        with ContBusRel do begin
          SetCurrentkey("Link to Table","No.");
          SetRange("Link to Table","link to table"::Customer);
          SetRange("No.",Cust."No.");
          if not FindFirst then
            exit;
          Cont.Get("Contact No.");
          OldCont := Cont;
        end;

        ContNo := Cont."No.";
        NoSeries := Cont."No. Series";
        Cont.Validate("E-Mail",Cust."E-Mail");
        Cont.TransferFields(Cust);
        Cont."No." := ContNo ;
        Cont."No. Series" := NoSeries;
        Cont.Validate(Name);
        Cont.OnModify(OldCont);
        Cont.Modify(true);
    end;


    procedure OnDelete(var Cust: Record Customer)
    var
        ContBusRel: Record "Contact Business Relation";
    begin
        with ContBusRel do begin
          SetCurrentkey("Link to Table","No.");
          SetRange("Link to Table","link to table"::Customer);
          SetRange("No.",Cust."No.");
          DeleteAll(true);
        end;
    end;


    procedure InsertNewContact(var Cust: Record Customer;LocalCall: Boolean)
    var
        ContBusRel: Record "Contact Business Relation";
        Cont: Record Contact;
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if not LocalCall then begin
          RMSetup.Get;
          RMSetup.TestField("Bus. Rel. Code for Customers");
        end;

        with Cont do begin
          Init;
          TransferFields(Cust);
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
          "Business Relation Code" := RMSetup."Bus. Rel. Code for Customers";
          "Link to Table" := "link to table"::Customer;
          "No." := Cust."No.";
          Insert(true);
        end;
    end;


    procedure InsertNewContactPerson(var Cust: Record Customer;LocalCall: Boolean)
    var
        ContComp: Record Contact;
        ContBusRel: Record "Contact Business Relation";
        Cont: Record Contact;
    begin
        if not LocalCall then begin
          RMSetup.Get;
          RMSetup.TestField("Bus. Rel. Code for Customers");
        end;

        ContBusRel.SetCurrentkey("Link to Table","No.");
        ContBusRel.SetRange("Link to Table",ContBusRel."link to table"::Customer);
        ContBusRel.SetRange("No.",Cust."No.");
        if ContBusRel.FindFirst then
          if ContComp.Get(ContBusRel."Contact No.") then
            with Cont do begin
              Init;
              "No." := '';
              Validate(Type,Type::Person);
              Insert(true);
              "Company No." := ContComp."No.";
              Validate(Name,Cust.Contact);
              InheritCompanyToPersonData(ContComp);
              Modify(true);
              Cust."Primary Contact No." := "No.";
            end
    end;
}

