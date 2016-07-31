--require "expansions/nef/nef"
--幻想清行『雾之湖·夏』
function c22400.initial_effect(c)

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c22400.target)
	e1:SetOperation(c22400.activate)
	c:RegisterEffect(e1)

end


function c22400.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end


function c22400.filter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and c:GetDefence()==900 and c:GetLevel()>0
end


function c22400.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(c22400.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local d,p,l = Nef.GetDate()
	local g=Duel.GetMatchingGroup(c22400.filter,tp,LOCATION_MZONE,0,nil)
	if (p>5 or p<10) and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(22400,0)) then
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(tc:GetLevel()*2)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end


function c22400.aclimit(e,re,tp)
	return re:GetHandler():IsOnField() and e:GetHandler()~=re:GetHandler()
end

