function  [SFeatures]= statisticalFeatures(x)

N = size(x,1);
    %T1. Mean
    FeaturesVector(1) = mean(x);
    %T2. Maxim value
    FeaturesVector(2) = max(x);
    %T3. Root mean square
    FeaturesVector(3) = sqrt(sum(x.^2)/N);
    %T4. Square Root mean
    FeaturesVector(4) = (sum(sqrt(abs(x)))/N)^2;
    %T5. Standard deviation
    FeaturesVector(5) = std(x,1);
    %T6. Variance
    FeaturesVector(6) = var(x,1);
    %T7. Shape factor (with RMS)
    FeaturesVector(7) = FeaturesVector(3)/((sum(abs(x)))/N);
    %T8. Shape factor (with SRM)
    FeaturesVector(8) = FeaturesVector(4)/((sum(abs(x)))/N);
    %T9. Crest factor
    FeaturesVector(9) = FeaturesVector(2)/FeaturesVector(3);
    %T10. Latitude factor
    FeaturesVector(10) = FeaturesVector(2)/FeaturesVector(4);
    %T11. Impulse factor
    FeaturesVector(11) = FeaturesVector(2)/((sum(abs(x)))/N);
    %T12. Skewness
    FeaturesVector(12) = skewness(x);
    %T13. Kurtosis
    FeaturesVector(13) = kurtosis(x);
    %T14. Normalised 5th central moment
    FeaturesVector(14) = moment(x,5)/((std(x,1)^5));
    %T15. Normalised 6th central moment
    FeaturesVector(15) = moment(x,6)/((std(x,1)^6));
    SFeatures = FeaturesVector;
end
