#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5152 "PesaFlow Integration"
{

    trigger OnRun()
    begin
    end;

    var
        PesaFlowIntegration: Record UnknownRecord77756;
        PesaFlowInvoices: Record UnknownRecord77757;


    procedure InsertAccomodationFee(paymentrefid: Code[20];customerref: Code[50];invoiceno: Code[20];invoiceamt: Decimal;paidamt: Decimal;channel: Text;paymentdate: Text;status: Text) inserted: Boolean
    var
        KUCCPSRaw: Record UnknownRecord70082;
        CoreBankingDetails: Record Core_Banking_Details;
        CoreBankingHeader: Record "Core_Banking Header";
        PesaFlow_ServiceIDs: Record "Pesa-Flow_Service-IDs";
        WebPortal: Codeunit webportals;
    begin
        Clear(PesaFlowInvoices);
        PesaFlowInvoices.Reset;
        PesaFlowInvoices.SetRange(BillRefNo,customerref);
        if PesaFlowInvoices.Find('-') then begin
          Clear(PesaFlowIntegration);
          PesaFlowIntegration.Reset;
          PesaFlowIntegration.SetRange(PaymentRefID,paymentrefid);
          if not PesaFlowIntegration.Find('-')then begin
            PesaFlowIntegration.Init;
            PesaFlowIntegration.PaymentRefID := paymentrefid;
            PesaFlowIntegration.CustomerRefNo := PesaFlowInvoices.CustomerRefNo;
            PesaFlowIntegration."Customer Name":=PesaFlowInvoices.CustomerName;
            PesaFlowIntegration.InvoiceNo := invoiceno;
            PesaFlowIntegration.InvoiceAmount := invoiceamt;
            PesaFlowIntegration.PaidAmount := paidamt;
            PesaFlowIntegration.ServiceID := PesaFlowInvoices.ServiceID;
            PesaFlowIntegration.Description:=PesaFlowInvoices.Description;
            PesaFlowIntegration.PaymentChannel := channel;
            PesaFlowIntegration.PaymentDate := paymentdate;
            PesaFlowIntegration.Status:=status;
            PesaFlowIntegration."Date Received":= Today;
           if  PesaFlowIntegration.Insert then begin
            inserted := true;
           // Get the Bank Account Mapped to the pesa Flow service Id
           Clear(PesaFlow_ServiceIDs);
           PesaFlow_ServiceIDs.Reset;
           PesaFlow_ServiceIDs.SetRange(Service_ID,PesaFlowInvoices.ServiceID);
           if not (PesaFlow_ServiceIDs.Find('-')) then Error('Invalid service ID');
           PesaFlow_ServiceIDs.TestField(Bank_Id);
           PesaFlow_ServiceIDs.CalcFields("Bank Name");
           //post to corebanking
           CoreBankingHeader.Init;
           CoreBankingHeader."Created By" :=UserId;
          CoreBankingHeader.Bank_Code := PesaFlow_ServiceIDs.Bank_Id;
          CoreBankingHeader."Created By" := UserId;
          CoreBankingHeader."Time Created" := Time;
          CoreBankingHeader."Date Created" :=Today;
           CoreBankingHeader."Statement No" := 'PESAF_INT'+PesaFlow_ServiceIDs.Bank_Id;
          if CoreBankingHeader.Insert then;
           Clear(CoreBankingDetails);
           CoreBankingDetails.Init;
           CoreBankingDetails.Bank_Code := PesaFlow_ServiceIDs.Bank_Id;
           CoreBankingDetails."Transaction Number" := paymentrefid;
           CoreBankingDetails."Statement No" := 'PESAF_INT'+PesaFlow_ServiceIDs.Bank_Id;
           CoreBankingDetails."Transaction Date" := ConvertToDate(paymentdate);//TODAY;
           CoreBankingDetails."Trans. Amount" := paidamt;
           CoreBankingDetails."Transaction Description" := 'Fee Receipt';
           CoreBankingDetails."Student No." := PesaFlowInvoices.CustomerRefNo;
           CoreBankingDetails."Posting Status" := CoreBankingDetails."posting status"::New;
          if  CoreBankingDetails.Insert then begin
             PesaFlowIntegration.Posted := true;
             PesaFlowIntegration.Modify;
             CoreBankingDetails.PostReceiptsFromBuffer(CoreBankingDetails);
             end else Error('Posting error!');
            end;
            end else begin
              Error('invalid transaction id');
        end;
        end else begin
          /*ERROR('invalid invoice');
        
          END*/
        KUCCPSRaw.Reset;
        KUCCPSRaw.SetRange(Admin,customerref);
        if KUCCPSRaw.Find('-') then begin
        PesaFlowIntegration.Reset;
        PesaFlowIntegration.SetRange(PaymentRefID,paymentrefid);
        if not PesaFlowIntegration.Find('-') then begin
          PesaFlowIntegration.Init;
          PesaFlowIntegration.PaymentRefID:=paymentrefid;
          PesaFlowIntegration.CustomerRefNo:=customerref;
          PesaFlowIntegration."Customer Name" := KUCCPSRaw.Names;
          PesaFlowIntegration.InvoiceNo:=invoiceno;
          PesaFlowIntegration.InvoiceAmount:=invoiceamt;
          PesaFlowIntegration.PaidAmount:=paidamt;
          PesaFlowIntegration.ServiceID:='2729151';
          PesaFlowIntegration.Description:='Payment for hostel charges';
          PesaFlowIntegration.PaymentChannel:=channel;
          PesaFlowIntegration.PaymentDate:=paymentdate;
          PesaFlowIntegration."Date Received":=Today;
          PesaFlowIntegration.Status:= status;
          if PesaFlowIntegration.Insert then begin
          inserted:=true;
           // Get the Bank Account Mapped to the pesa Flow service Id
           Clear(PesaFlow_ServiceIDs);
           PesaFlow_ServiceIDs.Reset;
           PesaFlow_ServiceIDs.SetRange(Service_ID,'2729151');
           if not (PesaFlow_ServiceIDs.Find('-')) then Error('Invalid service ID');
           PesaFlow_ServiceIDs.TestField(Bank_Id);
           PesaFlow_ServiceIDs.CalcFields("Bank Name");
           //post to corebanking
           CoreBankingHeader.Init;
           CoreBankingHeader."Created By" :=UserId;
          CoreBankingHeader.Bank_Code := PesaFlow_ServiceIDs.Bank_Id;
          CoreBankingHeader."Created By" := UserId;
          CoreBankingHeader."Time Created" := Time;
          CoreBankingHeader."Date Created" :=Today;
           CoreBankingHeader."Statement No" := 'PESAF_INT'+PesaFlow_ServiceIDs.Bank_Id;
          if CoreBankingHeader.Insert then;
           Clear(CoreBankingDetails);
           CoreBankingDetails.Init;
           CoreBankingDetails.Bank_Code := PesaFlow_ServiceIDs.Bank_Id;
           CoreBankingDetails."Transaction Number" := paymentrefid;
           CoreBankingDetails."Statement No" := 'PESAF_INT'+PesaFlow_ServiceIDs.Bank_Id;
           CoreBankingDetails."Transaction Date" := ConvertToDate(paymentdate);//TODAY;
           CoreBankingDetails."Trans. Amount" := paidamt;
           CoreBankingDetails."Transaction Description" := 'Accomodation Receipt';
           CoreBankingDetails."Student No." := customerref;
           CoreBankingDetails."Posting Status" := CoreBankingDetails."posting status"::New;
          if  CoreBankingDetails.Insert then begin
             PesaFlowIntegration.Posted := true;
             PesaFlowIntegration.Modify;
             CoreBankingDetails.PostReceiptsFromBuffer(CoreBankingDetails);
             WebPortal.MarkKUCCPSDetailsUpdated(customerref);
             end else Error('Posting error!');
            end;
          end else begin
            Error('invalid transaction id');
            end;
            end else begin
          Error('invalid invoice');
        
          end;
          end;

    end;


    procedure InsertCafeteriaTransaction(paymentrefid: Code[20];customerref: Code[50];invoiceno: Code[20];invoiceamt: Decimal;paidamt: Decimal;channel: Text;paymentdate: Text;status: Text) inserted: Boolean
    var
        KUCCPSRaw: Record UnknownRecord70082;
        CoreBankingDetails: Record Core_Banking_Details;
        CoreBankingHeader: Record "Core_Banking Header";
        PesaFlow_ServiceIDs: Record "Pesa-Flow_Service-IDs";
        WebPortal: Codeunit webportals;
    begin
        PesaFlowIntegration.Reset;
        PesaFlowIntegration.SetRange(PaymentRefID,paymentrefid);
        if not PesaFlowIntegration.Find('-') then begin
          PesaFlowIntegration.Init;
          PesaFlowIntegration.PaymentRefID:=paymentrefid;
          PesaFlowIntegration.CustomerRefNo:=customerref;
          PesaFlowIntegration.InvoiceNo:=invoiceno;
          PesaFlowIntegration.InvoiceAmount:=invoiceamt;
          PesaFlowIntegration.PaidAmount:=paidamt;
          PesaFlowIntegration.ServiceID:='2729111';
          PesaFlowIntegration.Description:='Payment for catering services';
          PesaFlowIntegration.PaymentChannel:=channel;
          PesaFlowIntegration.PaymentDate:=paymentdate;
          PesaFlowIntegration."Date Received":=Today;
          PesaFlowIntegration.Status:= status;
          if PesaFlowIntegration.Insert then begin
          inserted:=true;
          end else begin
            Error(paymentrefid + ' is a duplicate transaction ID!!!');
            end;
            end;
    end;


    procedure PesaFlowTransExists(paymentrefid: Code[20]) exists: Boolean
    begin
        PesaFlowIntegration.Reset;
        PesaFlowIntegration.SetRange(PaymentRefID,paymentrefid);
        if PesaFlowIntegration.Find('-') then begin
          exists:=true;
          end
    end;


    procedure PostPesaFlowFeeTrans(paymentrefid: Code[50];customerrefno: Code[50];invoiceno: Code[20];invoiceamt: Decimal;paidamt: Decimal;paymentchannel: Text;paymentdate: Text;status: Text) inserted: Boolean
    var
        Cust: Record Customer;
        BankIntergration: Record UnknownRecord77762;
        bank: Record UnknownRecord77762;
        AmountsDecimal: Decimal;
        KUCCPSRaw: Record UnknownRecord70082;
        CoreBankingDetails: Record Core_Banking_Details;
        CoreBankingHeader: Record "Core_Banking Header";
        PesaFlow_ServiceIDs: Record "Pesa-Flow_Service-IDs";
        WebPortal: Codeunit webportals;
    begin
        Clear(PesaFlowInvoices);
        PesaFlowInvoices.Reset;
        PesaFlowInvoices.SetRange(BillRefNo,customerrefno);
        if PesaFlowInvoices.Find('-') then begin
          Clear(PesaFlowIntegration);
          PesaFlowIntegration.Reset;
          PesaFlowIntegration.SetRange(PaymentRefID,paymentrefid);
          if not PesaFlowIntegration.Find('-')then begin
            PesaFlowIntegration.Init;
            PesaFlowIntegration.PaymentRefID := paymentrefid;
            PesaFlowIntegration.CustomerRefNo := PesaFlowInvoices.CustomerRefNo;
            PesaFlowIntegration."Customer Name":=PesaFlowInvoices.CustomerName;
            PesaFlowIntegration.InvoiceNo := invoiceno;
            PesaFlowIntegration.InvoiceAmount := invoiceamt;
            PesaFlowIntegration.PaidAmount := paidamt;
            PesaFlowIntegration.ServiceID := PesaFlowInvoices.ServiceID;
            PesaFlowIntegration.Description:=PesaFlowInvoices.Description;
            PesaFlowIntegration.PaymentChannel := paymentchannel;
            PesaFlowIntegration.PaymentDate := paymentdate;
            PesaFlowIntegration.Status:=status;
            PesaFlowIntegration."Date Received":= Today;
           if  PesaFlowIntegration.Insert then begin
            inserted := true;
           // Get the Bank Account Mapped to the pesa Flow service Id
           Clear(PesaFlow_ServiceIDs);
           PesaFlow_ServiceIDs.Reset;
           PesaFlow_ServiceIDs.SetRange(Service_ID,PesaFlowInvoices.ServiceID);
           if not (PesaFlow_ServiceIDs.Find('-')) then Error('Invalid service ID');
           PesaFlow_ServiceIDs.TestField(Bank_Id);
           PesaFlow_ServiceIDs.CalcFields("Bank Name");
           //post to corebanking
           CoreBankingHeader.Init;
           CoreBankingHeader."Created By" :=UserId;
          CoreBankingHeader.Bank_Code := PesaFlow_ServiceIDs.Bank_Id;
          CoreBankingHeader."Created By" := UserId;
          CoreBankingHeader."Time Created" := Time;
          CoreBankingHeader."Date Created" :=Today;
           CoreBankingHeader."Statement No" := 'PESAF_INT'+PesaFlow_ServiceIDs.Bank_Id;
          if CoreBankingHeader.Insert then;
           Clear(CoreBankingDetails);
           CoreBankingDetails.Init;
           CoreBankingDetails.Bank_Code := PesaFlow_ServiceIDs.Bank_Id;
           CoreBankingDetails."Transaction Number" := paymentrefid;
           CoreBankingDetails."Statement No" := 'PESAF_INT'+PesaFlow_ServiceIDs.Bank_Id;
           CoreBankingDetails."Transaction Date" := ConvertToDate(paymentdate);//TODAY;
           CoreBankingDetails."Trans. Amount" := paidamt;
           CoreBankingDetails."Transaction Description" := 'Fee Receipt';
           CoreBankingDetails."Student No." := PesaFlowInvoices.CustomerRefNo;
           CoreBankingDetails."Posting Status" := CoreBankingDetails."posting status"::New;
          if  CoreBankingDetails.Insert then begin
             PesaFlowIntegration.Posted := true;
             PesaFlowIntegration.Modify;
             CoreBankingDetails.PostReceiptsFromBuffer(CoreBankingDetails);
             end else Error('Posting error!');
            end;
            end else begin
              Error(paymentrefid +' is a duplicate transaction ID!!!');
        end;
        end else begin
          Error('invalid invoice');

          end

    end;


    procedure ConvertToInt(myText: Text) intValue: Integer
    var
        myInt: Integer;
    begin
        if Evaluate(myInt,myText)then begin
        exit(myInt);
          end else begin
            Error('Cannot convert ' +myText+' to integer!');
            end;
    end;


    procedure ConvertToDate(myText: Text) dateValue: Date
    begin
        begin
        dateValue := Dmy2date(ConvertToInt(CopyStr(myText,9,2)),ConvertToInt(CopyStr(myText,6,2)),ConvertToInt(CopyStr(myText,1,4)));
        exit(dateValue);
        end;
    end;
}

