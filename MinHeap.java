/* DSA 
 * MinHeap
 * Modifies version of code written in class
 */

// Does not need to be altered.

import java.util.*;

public class MinHeap<C extends Comparable>{
    // instance variables
    private ArrayList<C> heap;

    // constructor
    public MinHeap(){
	heap = new ArrayList<C>();
    }

    // private methods
    private int left(int pos) { return 2 * pos + 1; }
    private int right(int pos) { return 2 * pos + 2; }
    private int parent(int pos) { return (pos - 1) / 2; }
    
    private boolean isLessThan(int pos1, int pos2){
	return heap.get(pos1).compareTo(heap.get(pos2)) < 0;
    }
    private boolean hasTwoChildren(int pos){
	return right(pos) < heap.size();
    }
    private boolean hasChildren(int pos){
	return left(pos) < heap.size();
    }

    private int minChild(int pos){ 
	if (!hasChildren(pos)) return -1;
	if (hasTwoChildren(pos) && isLessThan(right(pos), left(pos)))
	    return right(pos);
	else return left(pos);
    }


    // public methods
    public C peek() {
	if (isEmpty()) return null;
	return heap.get(0);
    }
    public int size() { return heap.size(); }
    
    public boolean isEmpty() { return heap.size() == 0; }

    public void insert(C elt){
	heap.add(elt);
	int currPos = heap.size() - 1;
	while (parent(currPos) >= 0 && isLessThan(currPos, parent(currPos))){
	    C temp = heap.get(currPos);
	    heap.set(currPos, heap.get(parent(currPos)));
	    heap.set(parent(currPos), temp);
	    currPos = parent(currPos);
	}
    }

    public C remove(){
		if (isEmpty()) return null;
		C toReturn = heap.get(0);
		heap.set(0, heap.get(heap.size() - 1));
		heap.remove(heap.size() - 1);
	
		int currPos = 0;
		while (hasChildren(currPos) && isLessThan(minChild(currPos), currPos)){
		    C temp = heap.get(currPos);
		    int child = minChild(currPos);
		    heap.set(currPos, heap.get(child));
		    heap.set(child, temp);
		    currPos = child;	    
		}
		return toReturn;
    }

    public void print(){ System.out.println(heap); } //use this for testing
}
