--决战符『灵车漂移』
--require "expansions/nef/nef"
function c37004.initial_effect(c)
	--turnset
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_CANNOT_TURN_SET)
	e0:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c37004.condition)
	e1:SetTarget(c37004.target)
	e1:SetOperation(c37004.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	c:RegisterEffect(e2)

	if c37004.counter == nil then
		c37004.counter = true
		Uds.regUdsEffect(e1,37004)
		Uds.regUdsEffect(e2,37004)
	end
end
function c37004.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLocation()~=LOCATION_HAND and e:GetHandler():GetPreviousLocation()~=LOCATION_HAND and Duel.GetTurnCount()>=3
end

function c37004.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c37004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1=Duel.GetFieldGroupCount(tp,0,0xe)
	local ct2=Duel.GetFieldGroupCount(tp,0xe,0)
	local ct=0
	if Duel.GetMatchingGroupCount(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)>0 then ct=ct+1 end
	if Duel.GetMatchingGroupCount(c37004.filter,tp,0,LOCATION_ONFIELD,nil)>0  then ct=ct+1 end
	if Duel.GetMatchingGroupCount(Card.IsDestructable,tp,0,LOCATION_HAND,nil)>0 then ct=ct+1 end
	if chk==0 then
		if e:GetHandler() and e:GetHandler():IsOnField() then 
			return ct1/(ct2-1)==3 and ct>=2
		else
			return ct1/ct2==3 and ct>=2
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,0,1,0,0)
	if e:GetHandler() and e:GetHandler():IsOnField() then 
		Duel.SetChainLimit(c37004.chainlimit)
	end
end
function c37004.chainlimit(e,rp,tp)
	return e:GetHandler():IsSetCard(0x214)
end
function c37004.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(c37004.filter,tp,0,LOCATION_ONFIELD,nil)
	local g3=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_HAND,nil)
	local operation = {
		[1] = function()
			Duel.Destroy(g1,REASON_EFFECT)
		end,
		[2] = function ()
			Duel.Destroy(g2,REASON_EFFECT)
		end,
		[3] = function ()
			Duel.Destroy(g3,REASON_EFFECT)
		end,
	}
	local cond = {
		[1] = g1:GetCount()>0,
		[2] = g2:GetCount()>0,
		[3] = g3:GetCount()>0,
	}
	if #cond<2 then return end
	local t = {}
	local count = 1
	for i=1,3 do
		if cond[i]==true then
			t[count] = {desc = aux.Stringid(37004,i), op = operation[i]}
			count=count+1
		end
	end
	-- process
	for me=1,2 do
		local opt = Duel.SelectOption(tp, Nef.unpackOneMember(t, "desc"))+1
		t[opt].op()
		table.remove(t, opt)
	end
end
