// [[Rcpp::depends(RcppProgress)]]
#include <progress.hpp>
#include <progress_bar.hpp>
#include <vector>
#include <algorithm>

using namespace Rcpp;
using std::endl;
using std::upper_bound;

// Enable C++11 via this plugin (Rcpp 0.10.3 or later)
// [[Rcpp::plugins(cpp11)]]

// [[Rcpp::export]]
DataFrame lordstar_async_faster(NumericVector pval,
	IntegerVector E,
	NumericVector gammai,
	double w0 = 0.005,
	double alpha = 0.05,
	bool display_progress = true) {

	int N = pval.size();

	NumericVector alphai(N);
	NumericVector Rdec(0);
	LogicalVector R(N);
	alphai[0] = gammai[0] * w0;
	R[0] = (pval[0] <= alphai[0]);
	
	NumericVector Rdectest(N);
	Rdectest[1] = 1;
	
	Progress p(N * N, display_progress);

	for (int i = 1; i < N; i++) {
	  NumericVector r(0);
	  int cond = 0;
	  
		for (int j = 0; j <= i-1; j++) {
			p.increment();
		  
			if (R[j] && (E[j]-1 <= i-1)) {
				cond += 1;
			}
		}
		
		Rdec.push_back(cond);
		
		if(max(Rdec) > 0){
		  for (int y = 0; y < max(Rdec); y++) {
		    int z = upper_bound(Rdec.begin(), Rdec.end(), y) - Rdec.begin();
		    r.push_back(z);
		  }
		}
		
		if(r.size() <= 1) {

			if(r.size() > 0){

				alphai[i] = gammai[i] * w0 + (alpha - w0) * gammai[i-r[0]-1];

			} else {

				alphai[i] = gammai[i] * w0;
			}

			R[i] = (pval[i] <= alphai[i]); 

		} else {

			double gammaisum = 0;
			int bound = r.size();

			for (int g = 1; g < bound; g++) {
				gammaisum += gammai[i-r[g]-1];
			}

			alphai[i] = gammai[i] * w0 + (alpha - w0) * gammai[i-r[0]-1] + 
			  alpha * gammaisum;
			R[i] = (pval[i] <= alphai[i]);
		}
	}

	return DataFrame::create(_["pval"] = pval,
		_["alphai"] = alphai,
		_["R"] = R);

}

// [[Rcpp::export]]
DataFrame lordstar_dep_faster(NumericVector pval,
	IntegerVector L,
	NumericVector gammai,
	double w0 = 0.005,
	double alpha = 0.05,
	bool display_progress = true) {

	int N = pval.size();

	NumericVector alphai(N);
	NumericVector Rlag(0);
	LogicalVector R(N);
	alphai[0] = gammai[0] * w0;
	R[0] = (pval[0] <= alphai[0]);

	Progress p(N * N, display_progress);

	for (int i = 1; i < N; i++) {
	  NumericVector r(0);
	  int cond = 0;
	  
	  if (i-1-L[i] >= 0){
	    for (int j = 0; j < i - L[i]; j++) {
	      p.increment();
	      
	      if (R[j]){
	        cond += 1;
	      }
	    }
	  }
	  
	  Rlag.push_back(cond);
		
		for (int y = 0; y < max(Rlag); y++) {
		  int z = upper_bound(Rlag.begin(), Rlag.end(), y) - Rlag.begin();
		  r.push_back(z);
		}

		if(r.size() <= 1) {

			if(r.size() > 0){

				alphai[i] = gammai[i] * w0 + (alpha - w0) * gammai[i-r[0]-1];

			} else {

				alphai[i] = gammai[i] * w0;

			}
			R[i] = (pval[i] <= alphai[i]); 

		} else {

			double gammaisum = 0;
			int bound = r.size();

			for (int g = 1; g < bound; g++) {
				gammaisum += gammai[i-r[g]-1];
			}
			
			alphai[i] = gammai[i] * w0 + (alpha - w0) * gammai[i-r[0]-1] + 
			  alpha * gammaisum;
			R[i] = (pval[i] <= alphai[i]);
		}
	}

	return DataFrame::create(_["pval"] = pval,
		_["lag"] = L,
		_["alphai"] = alphai,
		_["R"] = R);

}

// [[Rcpp::export]]
List lordstar_batch_faster(NumericVector pval,
	IntegerVector batch,
	IntegerVector batchsum,
	NumericVector gammai,
	double w0 = 0.005,
	double alpha = 0.05,
	bool display_progress = true) {

	int B = batch.size();

	NumericMatrix alphai(B, max(batch));
	LogicalMatrix R(B, max(batch));

	int mysum = 0;
	for (int a = 1; a < batch.size(); a++) {
		mysum += batch[a];
	}

	Progress p(mysum, display_progress);

	for (int i = 0; i < batch[0]; i++) {
		alphai(0,i) = gammai[i] * w0;
		R(0,i) = (pval[i] <= alphai(0,i));
	}

	for (int b = 1; b < B; b++) {
		NumericVector rcum = cumsum(static_cast<NumericVector>(rowSums(R)));

		for (int x = 0; x < batch[b]; x++) {
			p.increment();
			NumericVector r(0);
			if (max(rcum) > 0) {
				for (int y = 0; y < max(rcum); y++) {
          int z = upper_bound(rcum.begin(), rcum.end(), y) - rcum.begin();
				  r.push_back(z);
			  }
			}

			if(r.size() <= 1) {
				if(r.size() > 0){
					alphai(b,x) = gammai[batchsum[b-1] + x] * w0 + (alpha - w0) * 
					gammai[batchsum[b-1] + x - batchsum[r[0]]];

				} else {
					alphai(b,x) = gammai[batchsum[b-1] + x] * w0;
				}
				R(b,x) = (pval[batchsum[b-1] + x] <= alphai(b,x));
			} else {
				double gammaisum = 0;
				int bound = r.size();
				for (int g = 1; g < bound; g++) {
					gammaisum += gammai[batchsum[b-1] + x - batchsum[r[g]]];
				}
				alphai(b,x) = gammai[batchsum[b-1] + x] * w0 + (alpha - w0) * 
				gammai[batchsum[b-1] + x - batchsum[r[0]]] + 
				alpha * gammaisum;
				R(b,x) = (pval[batchsum[b-1] + x] <= alphai(b,x));
			}

		}
	}

	return List::create(
		_["alphai"] = alphai,
		_["R"] = R);
}