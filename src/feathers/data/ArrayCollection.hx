/*
	Feathers UI
	Copyright 2019 Bowler Hat LLC. All Rights Reserved.

	This program is free software. You can redistribute and/or modify it in
	accordance with the terms of the accompanying license agreement.
 */

package feathers.data;

import openfl.errors.RangeError;
import openfl.events.Event;
import feathers.events.FlatCollectionEvent;
import feathers.events.FeathersEvent;
import openfl.events.EventDispatcher;

/**
	Wraps an `Array` in the common `IFlatCollection` API used for data
	collections by many Feathers UI controls, including `ListBox` and `TabBar`

	@since 1.0.0
**/
class ArrayCollection<T> extends EventDispatcher implements IFlatCollection<T> {
	public function new(?array:Array<T>) {
		super();
		if (array == null) {
			array = [];
		}
		this.array = array;
	}

	/**
		The `Array` data source for this collection.

		@since 1.0.0
	**/
	public var array(default, set):Array<T> = null;

	private function set_array(value:Array<T>):Array<T> {
		if (this.array == value) {
			return this.array;
		}
		if (value == null) {
			value = [];
		}
		this.array = value;
		FeathersEvent.dispatch(this, FlatCollectionEvent.RESET);
		FeathersEvent.dispatch(this, Event.CHANGE);
		return this.array;
	}

	/**
		The number of items in the collection.

		@since 1.0.0
	**/
	public var length(get, never):Int;

	private function get_length():Int {
		return this.array.length;
	}

	/**
		Returns the item at the specified index in the collection.

		@since 1.0.0
	**/
	public function get(index:Int):T {
		return this.array[index];
	}

	/**
		Replaces the item at the specified index in the collection with a new
		item.

		@since 1.0.0
	**/
	public function set(index:Int, item:T):Void {
		if (index < 0 || index > this.array.length) {
			throw new RangeError('Failed to set item at index ${index}. Expected a value between 0 and ${this.array.length}.');
		}
		this.array[index] = item;
		FlatCollectionEvent.dispatch(this, FlatCollectionEvent.REPLACE_ITEM, index);
		FeathersEvent.dispatch(this, Event.CHANGE);
	}

	/**
		Inserts an item at the end of the collection, increasing the `length` by
		one.

		@since 1.0.0
	**/
	public function add(item:T):Void {
		inline this.addAt(item, this.array.length);
	}

	/**
		Inserts an item into the collection at the specified index, increasing
		the `length` by one.

		@since 1.0.0
	**/
	public function addAt(item:T, index:Int):Void {
		if (index < 0 || index > this.array.length) {
			throw new RangeError('Failed to add item at index ${index}. Expected a value between 0 and ${this.array.length}.');
		}
		this.array.insert(index, item);
		FlatCollectionEvent.dispatch(this, FlatCollectionEvent.ADD_ITEM, index);
		FeathersEvent.dispatch(this, Event.CHANGE);
	}

	/**
		@since 1.0.0
	**/
	public function addAll(collection:IFlatCollection<T>):Void {
		for (item in collection) {
			this.add(item);
		}
	}

	/**
		@since 1.0.0
	**/
	public function addAllAt(collection:IFlatCollection<T>, index:Int):Void {
		if (index < 0 || index > this.array.length) {
			throw new RangeError('Failed to add collection at index ${index}. Expected a value between 0 and ${this.array.length}.');
		}
		for (item in collection) {
			this.addAt(item, index);
			index++;
		}
	}

	/**
		@since 1.0.0
	**/
	public function reset(collection:IFlatCollection<T>):Void {
		this.array.resize(0);
		for (item in collection) {
			this.array.push(item);
		}
		FlatCollectionEvent.dispatch(this, FlatCollectionEvent.RESET, -1);
		FeathersEvent.dispatch(this, Event.CHANGE);
	}

	/**
		Removes a specific item from the collection, decreasing the `length` by
		one, if the item is in the collection.

		@since 1.0.0
	**/
	public function remove(item:T):Void {
		var index = this.array.indexOf(item);
		if (index == -1) {
			// the item is not in the collection
			return;
		}
		this.array.remove(item);
		FlatCollectionEvent.dispatch(this, FlatCollectionEvent.REMOVE_ITEM, index);
		FeathersEvent.dispatch(this, Event.CHANGE);
	}

	/**
		Removes an item from the collection at the specified index, decreasing
		the `length` by one.

		@since 1.0.0
	**/
	public function removeAt(index:Int):T {
		if (index < 0 || index >= this.array.length) {
			throw new RangeError('Failed to remove item at index ${index}. Expected a value between 0 and ${this.array.length - 1}.');
		}
		var item = this.array[index];
		this.array.remove(item);
		FlatCollectionEvent.dispatch(this, FlatCollectionEvent.REMOVE_ITEM, index);
		FeathersEvent.dispatch(this, Event.CHANGE);
		return item;
	}

	/**
		Removes all items from the collection, decreasing its length to zero.

		@since 1.0.0
	**/
	public function removeAll():Void {
		this.array.resize(0);
		FlatCollectionEvent.dispatch(this, FlatCollectionEvent.REMOVE_ALL, -1);
		FeathersEvent.dispatch(this, Event.CHANGE);
	}

	/**
		Returns the index of the specified item, or `-1` if the item is not in
		the collection.

		@since 1.0.0
	**/
	public function indexOf(item:T):Int {
		return this.array.indexOf(item);
	}

	/**
		@since 1.0.0
	**/
	public function contains(item:T):Bool {
		return this.array.indexOf(item) != -1;
	}

	/**
		@since 1.0.0
	**/
	public function iterator():Iterator<T> {
		return this.array.iterator();
	}

	/**
		@since 1.0.0
	**/
	public function updateAt(index:Int):Void {
		if (index < 0 || index >= this.array.length) {
			throw new RangeError('Failed to update item at index ${index}. Expected a value between 0 and ${this.array.length - 1}.');
		}
		FlatCollectionEvent.dispatch(this, FlatCollectionEvent.UPDATE_ITEM, index);
	}

	/**
		@since 1.0.0
	**/
	public function updateAll():Void {
		FlatCollectionEvent.dispatch(this, FlatCollectionEvent.UPDATE_ALL, -1);
	}
}
