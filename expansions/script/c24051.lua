--罠符「捕捉之网」
function c24051.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCost(c24051.cost)
	e1:SetTarget(c24051.target)
	e1:SetOperation(c24051.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c24051.target2)
	e3:SetOperation(c24051.activate2)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	c:RegisterEffect(e4)
end
function c24051.cfilter(c)
	return c:IsSetCard(0x208) and c:IsRace(RACE_INSECT)
end
function c24051.yfilter(c)
	return c:IsSetCard(0x262)
end
function c24051.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=0
	if Duel.CheckReleaseGroupEx(tp,c24051.cfilter,2,nil) then ct=ct+1 end
	if Duel.CheckReleaseGroupEx(tp,c24051.yfilter,1,nil) then ct=ct+1 end
	if chk==0 then return ct>0 end
		local g=Duel.SelectReleaseGroupEx(tp,c24051.cfilter,1,1,nil)
		if g and g:GetFirst():IsSetCard(0x262) then
		elseif g then
			g1=Duel.SelectReleaseGroupEx(tp,c24051.cfilter,1,1,g:GetFirst())
			g:Merge(g1)
		else
			g=Duel.SelectReleaseGroupEx(tp,c24051.yfilter,1,1,nil)
		end
		Duel.Release(g,REASON_COST)
end
function c24051.filter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e) and c:GetControler()~=tp and c:IsControlerCanBeChanged()
end
function c24051.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return c24051.filter(tc,e,tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0)
end
function c24051.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) and tc:IsControlerCanBeChanged() and tc:IsControler(1-tp) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_TRIGGER)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(1)
		tc:RegisterEffect(e2)
		Duel.GetControl(tc,tp)
	end
end
function c24051.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c24051.filter,1,nil,e,tp) end
	local g=eg:Filter(c24051.filter,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
end
function c24051.filter3(c,e,tp)
	return c:IsFaceup() and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE) and c:IsControlerCanBeChanged() and c:IsControler(1-tp)
end
function c24051.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c24051.filter3,nil,e,tp)
	if g:GetCount()>0 then
		tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_TRIGGER)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue(1)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			e3:SetValue(1)
			tc:RegisterEffect(e3,true)
			Duel.GetControl(tc,tp)
			tc=g:GetNext()
		end
	end
end
