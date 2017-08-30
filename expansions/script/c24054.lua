--瘴符「瘴气场」
function c24054.initial_effect(c)
	c:SetUniqueOnField(1,0,24054)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c24054.activate)
	c:RegisterEffect(e1)
	--e
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_AVAILABLE_BD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetCondition(c24054.condition)
	e2:SetValue(c24054.rdval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c24054.condition)
	e3:SetValue(c24054.valcon)
	c:RegisterEffect(e3)
	if not c24054.global_check then
		c24054.global_check=true
		c24054[0]=false
		c24054[1]=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(c24054.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c24054.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c24054.checkop(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(r,REASON_BATTLE)==0 then
		c24054[ep]=true
	end
end
function c24054.clear(e,tp,eg,ep,ev,re,r,rp)
	c24054[0]=false
	c24054[1]=false
end
function c24054.filter(c,e,tp)
	return c:IsCode(24004) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c24054.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c24054.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(24054,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c24054.condition(e)
	return c24054[1-e:GetHandler():GetControler()]
end
function c24054.rdval(e,re,val,r,rp,rc)
	return val/2
end
function c24054.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
