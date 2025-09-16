#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50030 ConsumeObject13
{

    trigger OnRun()
    begin
        //------------------------Create Json
        if IsNull(StringBuilder) then
          Initialize;
        Clear(SalesHeader);
        SalesHeader.Reset;
        //SalesHeader.SETRANGE("Document Type",SalesHeader."Document Type"::Order);
        SalesHeader.SetFilter("No.",'PV-39700');
        if SalesHeader.FindFirst then
        //JsonTextWriter.WriteStartArray;
           begin repeat
            JsonTextWriter.WriteStartObject;
            JsonTextWriter.WritePropertyName('DocumentNo');
            JsonTextWriter.WriteValue(SalesHeader."No.");
            //Create Branch of Address  Start
            JsonTextWriter.WritePropertyName('Address');
            JsonTextWriter.WriteStartObject;
            JsonTextWriter.WritePropertyName('Address1');
            JsonTextWriter.WriteValue(SalesHeader."On Behalf Of");
            JsonTextWriter.WritePropertyName('City');
            JsonTextWriter.WriteValue(SalesHeader."Document Type");
            JsonTextWriter.WriteEndObject;
            //Create Branch of Address  End
            //Create Array of Item Details  Start
            JsonTextWriter.WritePropertyName('ItemDetails');
            JsonTextWriter.WriteStartArray;
            Clear(SalesLine);
            SalesLine.Reset;
            //SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
            SalesLine.SetRange(No,SalesHeader."No.");
            if SalesLine.FindSet then
            repeat
                 JsonTextWriter.WriteStartObject;
                 JsonTextWriter.WritePropertyName('ItemNo');
                 JsonTextWriter.WriteValue(SalesLine.No);
                 JsonTextWriter.WritePropertyName('PrName');
                 JsonTextWriter.WriteValue(SalesLine."Account Name");
                 JsonTextWriter.WriteEndObject;
            until SalesLine.Next =0;
            JsonTextWriter.WriteEndArray;
            JsonTextWriter.WriteEndObject;
        until SalesHeader.Next =0;
        end;
        JsonTextWriter.Flush;
        JSonString:=GetJSon;
        Message(JSonString);
    end;

    var
        JSonString: dotnet String;
        JObject: dotnet JObject;
        ArrayString: Text;
        JSONArray: dotnet JArray;
        SalesHeader: Record UnknownRecord61688;
        SalesLine: Record UnknownRecord61705;
        ArrayString1: dotnet String;
        JToken: dotnet JToken;
        TempJObject: dotnet JObject;
        counter: Variant;
        JsonTextWriter: dotnet JsonTextWriter;
        StringBuilder: dotnet StringBuilder;
        StringWriter: dotnet StringWriter;
        JsonFormatting: dotnet Formatting;
        GlobalNULL: Variant;

    local procedure Initialize()
    begin
        StringBuilder := StringBuilder.StringBuilder;
        StringWriter := StringWriter.StringWriter(StringBuilder);
        JsonTextWriter := JsonTextWriter.JsonTextWriter(StringWriter);
        JsonTextWriter.Formatting := JsonFormatting.Indented;

        Clear(GlobalNULL);
    end;


    procedure GetJSon() JSon: Text
    begin
        JSon := StringBuilder.ToString;
        Initialize;
    end;

    trigger Jobject::PropertyChanged(sender: Variant;e: dotnet PropertyChangedEventArgs)
    begin
    end;

    trigger Jobject::PropertyChanging(sender: Variant;e: dotnet PropertyChangingEventArgs)
    begin
    end;

    trigger Jobject::ListChanged(sender: Variant;e: dotnet ListChangedEventArgs)
    begin
    end;

    trigger Jobject::AddingNew(sender: Variant;e: dotnet AddingNewEventArgs)
    begin
    end;

    trigger Jobject::CollectionChanged(sender: Variant;e: dotnet NotifyCollectionChangedEventArgs)
    begin
    end;

    trigger Jsonarray::ListChanged(sender: Variant;e: dotnet ListChangedEventArgs)
    begin
    end;

    trigger Jsonarray::AddingNew(sender: Variant;e: dotnet AddingNewEventArgs)
    begin
    end;

    trigger Jsonarray::CollectionChanged(sender: Variant;e: dotnet NotifyCollectionChangedEventArgs)
    begin
    end;

    trigger Tempjobject::PropertyChanged(sender: Variant;e: dotnet PropertyChangedEventArgs)
    begin
    end;

    trigger Tempjobject::PropertyChanging(sender: Variant;e: dotnet PropertyChangingEventArgs)
    begin
    end;

    trigger Tempjobject::ListChanged(sender: Variant;e: dotnet ListChangedEventArgs)
    begin
    end;

    trigger Tempjobject::AddingNew(sender: Variant;e: dotnet AddingNewEventArgs)
    begin
    end;

    trigger Tempjobject::CollectionChanged(sender: Variant;e: dotnet NotifyCollectionChangedEventArgs)
    begin
    end;
}

